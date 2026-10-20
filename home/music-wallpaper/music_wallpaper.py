#!/usr/bin/env python3
"""Noctalia music wallpaper mode and carousel controller.

Invoked by Noctalia hooks and two user systemd services. All mode changes are
triggered by selecting selector images in Noctalia's own wallpaper picker.
"""

from __future__ import annotations

import base64
import fcntl
import hashlib
import io
import json
import os
import random
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFilter, ImageFont, ImageOps

HOME = Path.home()
WALLPAPER_DIR = HOME / "Pictures" / "Wallpapers"
MUSIC_SELECTOR = WALLPAPER_DIR / "00-music-theme.png"
CAROUSEL_SELECTOR = WALLPAPER_DIR / "01-carroussel.png"
MUSIC_CANONICAL = MUSIC_SELECTOR

STATE_HOME = Path(os.environ.get("XDG_STATE_HOME", str(HOME / ".local/state")))
CACHE_HOME = Path(os.environ.get("XDG_CACHE_HOME", str(HOME / ".cache")))
STATE_DIR = STATE_HOME / "noctalia-music-wallpaper"
CACHE_DIR = CACHE_HOME / "noctalia-music-wallpaper"
RENDERS_DIR = CACHE_DIR / "renders"
ART_CACHE_DIR = CACHE_DIR / "artwork"
RUNTIME_ROOT = Path(os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"))
RUNTIME_DIR = RUNTIME_ROOT / "noctalia-music-wallpaper"
MODE_FILE = RUNTIME_DIR / "mode"
LAST_NORMAL_FILE = STATE_DIR / "last-normal-wallpaper"
LAST_RENDER_FILE = STATE_DIR / "last-music-render"
EXPECTED_FILE = RUNTIME_DIR / "expected-wallpaper.json"
LAST_SELECTOR_FILE = RUNTIME_DIR / "last-selector.json"
SCREEN_SIZE_FILE = STATE_DIR / "screen-size.json"
LOCK_FILE = RUNTIME_DIR / "hook.lock"
LOG_FILE = STATE_DIR / "music-wallpaper.log"

MUSIC_SERVICE = "noctalia-music-wallpaper.service"
CAROUSEL_SERVICE = "noctalia-wallpaper-carousel.service"
IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".avif", ".tif", ".tiff"}
INTERNAL_CACHE_PATHS = (RENDERS_DIR,)
EXPECTED_TTL = 30.0
SELECTOR_DEBOUNCE = 2.5
DEFAULT_INTERVAL = max(60, int(os.environ.get("NOCTALIA_WALLPAPER_INTERVAL", "600")))


def log(message: str) -> None:
    line = f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}"
    print(line, flush=True)
    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        with LOG_FILE.open("a", encoding="utf-8") as handle:
            handle.write(line + "\n")
    except OSError:
        pass


def read_text(path: Path, default: str = "") -> str:
    try:
        return path.read_text(encoding="utf-8").strip()
    except OSError:
        return default


def write_text_atomic(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(value + "\n", encoding="utf-8")
    temporary.replace(path)


def current_mode() -> str:
    mode = read_text(MODE_FILE, "normal")
    return mode if mode in {"normal", "music", "carousel"} else "normal"


def set_mode(mode: str) -> None:
    write_text_atomic(MODE_FILE, mode)
    log(f"Mode set to {mode}")


def resolved(path: str | Path) -> Path:
    return Path(path).expanduser().resolve(strict=False)


def same_path(a: str | Path, b: str | Path) -> bool:
    try:
        return resolved(a) == resolved(b)
    except (OSError, RuntimeError):
        return str(a) == str(b)


def is_in_dir(path: str | Path, directory: Path) -> bool:
    try:
        resolved(path).relative_to(directory.resolve(strict=False))
        return True
    except (ValueError, OSError, RuntimeError):
        return False


def is_music_selector(path: str | Path) -> bool:
    # The same visible file is both the selector and the canonical latest output.
    # The active wallpaper itself is rendered to the internal cache directory.
    return same_path(path, MUSIC_SELECTOR)


def is_carousel_selector(path: str | Path) -> bool:
    return same_path(path, CAROUSEL_SELECTOR)


def is_internal_music_render(path: str | Path) -> bool:
    return is_in_dir(path, RENDERS_DIR)


def is_mode_wallpaper(path: str | Path) -> bool:
    return (
        is_music_selector(path)
        or same_path(path, MUSIC_CANONICAL)
        or is_carousel_selector(path)
        or is_internal_music_render(path)
    )


def run_command(
    args: list[str], *, timeout: float = 12.0
) -> subprocess.CompletedProcess[str]:
    try:
        return subprocess.run(
            args, text=True, capture_output=True, timeout=timeout, check=False
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        return subprocess.CompletedProcess(args, 1, "", str(error))


def noctalia(*args: str) -> subprocess.CompletedProcess[str]:
    return run_command(["noctalia", "msg", *args], timeout=20.0)


def wallpaper_get() -> str:
    result = noctalia("wallpaper-get")
    if result.returncode == 0:
        return result.stdout.strip()
    log(f"Could not query current wallpaper: {result.stderr.strip()}")
    return ""


def remember_normal(path: str | Path) -> None:
    value = str(Path(path).expanduser())
    if not value or value.startswith("color:") or is_mode_wallpaper(value):
        return
    write_text_atomic(LAST_NORMAL_FILE, value)


def last_normal() -> str:
    value = read_text(LAST_NORMAL_FILE)
    if value and Path(value).expanduser().is_file() and not is_mode_wallpaper(value):
        return str(Path(value).expanduser())
    return ""


def last_music_render() -> str:
    value = read_text(LAST_RENDER_FILE)
    if value and Path(value).is_file() and is_in_dir(value, RENDERS_DIR):
        return value
    return ""


def mark_expected(path: str | Path) -> None:
    """Remember several in-flight paths; Noctalia may emit hooks per monitor."""
    RUNTIME_DIR.mkdir(parents=True, exist_ok=True)
    entries: dict[str, float] = {}
    try:
        previous = json.loads(EXPECTED_FILE.read_text(encoding="utf-8"))
        raw = previous.get("paths", {}) if isinstance(previous, dict) else {}
        if isinstance(raw, dict):
            entries = {
                str(key): float(value)
                for key, value in raw.items()
                if time.time() - float(value) <= EXPECTED_TTL
            }
    except (OSError, ValueError, TypeError, json.JSONDecodeError):
        entries = {}
    entries[str(resolved(path))] = time.time()
    # Keep state bounded if several tracks change very quickly.
    entries = dict(sorted(entries.items(), key=lambda item: item[1], reverse=True)[:20])
    temporary = EXPECTED_FILE.with_suffix(".tmp")
    temporary.write_text(json.dumps({"paths": entries}), encoding="utf-8")
    temporary.replace(EXPECTED_FILE)


def consume_expected(path: str | Path) -> bool:
    try:
        payload = json.loads(EXPECTED_FILE.read_text(encoding="utf-8"))
        paths = payload.get("paths", {})
    except (OSError, ValueError, TypeError, json.JSONDecodeError):
        return False
    if not isinstance(paths, dict):
        return False
    now = time.time()
    matched = False
    cleaned: dict[str, float] = {}
    for value, timestamp in paths.items():
        try:
            age = now - float(timestamp)
        except (ValueError, TypeError):
            continue
        if age > EXPECTED_TTL:
            continue
        cleaned[str(value)] = float(timestamp)
        if same_path(path, str(value)):
            matched = True
    if cleaned != paths:
        try:
            temporary = EXPECTED_FILE.with_suffix(".tmp")
            temporary.write_text(json.dumps({"paths": cleaned}), encoding="utf-8")
            temporary.replace(EXPECTED_FILE)
        except OSError:
            pass
    return matched


def set_wallpaper(path: str | Path) -> bool:
    image_path = str(Path(path).expanduser())
    if not Path(image_path).is_file():
        log(f"Refusing to set missing wallpaper: {image_path}")
        return False
    mark_expected(image_path)
    result = noctalia("wallpaper-set", image_path)
    if result.returncode != 0:
        log(f"Noctalia wallpaper-set failed for {image_path}: {result.stderr.strip()}")
        return False
    log(f"Applied wallpaper: {image_path}")
    return True


def service(action: str, unit: str) -> None:
    result = run_command(["systemctl", "--user", action, unit], timeout=15.0)
    if result.returncode != 0 and (result.stderr or result.stdout):
        log(
            f"systemctl --user {action} {unit}: {(result.stderr or result.stdout).strip()}"
        )


def remember_selector_event(path: str | Path) -> bool:
    """Return True for a repeated per-monitor event for the same selector."""
    key = str(resolved(path))
    now = time.time()
    try:
        old = json.loads(LAST_SELECTOR_FILE.read_text(encoding="utf-8"))
        if (
            old.get("path") == key
            and now - float(old.get("time", 0)) < SELECTOR_DEBOUNCE
        ):
            return True
    except (OSError, ValueError, TypeError, json.JSONDecodeError):
        pass
    RUNTIME_DIR.mkdir(parents=True, exist_ok=True)
    temporary = LAST_SELECTOR_FILE.with_suffix(".tmp")
    temporary.write_text(json.dumps({"path": key, "time": now}), encoding="utf-8")
    temporary.replace(LAST_SELECTOR_FILE)
    return False


def ensure_fallback_image() -> None:
    """Keep the Home Manager-managed selector untouched."""
    if not MUSIC_SELECTOR.is_file():
        log(f"Music selector image is missing: {MUSIC_SELECTOR}")


# def ensure_fallback_image() -> None:
#     """Create a safe first-run wallpaper until a player provides artwork."""
#     if MUSIC_CANONICAL.is_file():
#         return
#     WALLPAPER_DIR.mkdir(parents=True, exist_ok=True)
#     width, height = screen_size()
#     base = Image.new("RGB", (width, height), (9, 10, 22)).convert("RGBA")
#     glow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
#     glow_draw = ImageDraw.Draw(glow)
#     glow_draw.ellipse((width * .15, -height * .45, width * .9, height * .8), fill=(56, 29, 105, 150))
#     glow_draw.ellipse((width * .4, height * .35, width * 1.1, height * 1.2), fill=(14, 82, 110, 100))
#     glow = glow.filter(ImageFilter.GaussianBlur(max(24, min(width, height) // 5)))
#     base = Image.alpha_composite(base, glow).convert("RGB")
#     draw = ImageDraw.Draw(base)
#     font = load_font(max(20, min(width, height) // 35))
#     small = load_font(max(13, min(width, height) // 75))
#     draw.text((width // 2, height // 2 - 24), "MUSIC WALLPAPER", anchor="mm", font=font, fill=(227, 226, 245))
#     draw.text((width // 2, height // 2 + 30), "Play something to bring the album art to life", anchor="mm", font=small, fill=(163, 163, 188))
#     save_image_atomic(base, MUSIC_CANONICAL)
#     log(f"Created initial fallback image at {MUSIC_CANONICAL}")


def enter_music_mode() -> None:
    set_mode("music")
    service("stop", CAROUSEL_SERVICE)
    ensure_fallback_image()
    target = last_music_render() or str(MUSIC_CANONICAL)
    set_wallpaper(target)
    service("start", MUSIC_SERVICE)


def enter_carousel_mode() -> None:
    set_mode("carousel")
    service("stop", MUSIC_SERVICE)
    if not apply_random_wallpaper():
        set_mode("normal")
        previous = last_normal()
        if previous:
            set_wallpaper(previous)
        log(
            "Carousel mode could not start because no ordinary wallpaper images were found"
        )
        return
    service("start", CAROUSEL_SERVICE)


def startup() -> None:
    """Always start with mode off; recover from a stale special wallpaper."""
    RUNTIME_DIR.mkdir(parents=True, exist_ok=True)
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    with LOCK_FILE.open("a", encoding="utf-8") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        # Clear stale expectations/debounce state from an earlier login.
        for stale_file in (EXPECTED_FILE, LAST_SELECTOR_FILE):
            try:
                stale_file.unlink()
            except OSError:
                pass
        prior = wallpaper_get()
        if (
            prior
            and not is_mode_wallpaper(prior)
            and Path(prior).expanduser().is_file()
        ):
            remember_normal(prior)
        set_mode("normal")
        service("stop", MUSIC_SERVICE)
        service("stop", CAROUSEL_SERVICE)
        if prior and is_mode_wallpaper(prior):
            restore = last_normal()
            if restore:
                log(f"Restoring normal wallpaper after startup: {restore}")
                set_wallpaper(restore)
            else:
                log("Startup found a special wallpaper but no saved normal wallpaper")
        ensure_fallback_image()
        log("Startup initialized; music mode and carousel are both off")


def wallpaper_hook() -> None:
    path = os.environ.get("NOCTALIA_WALLPAPER_PATH", "").strip()
    if not path:
        log("wallpaper_changed hook has no NOCTALIA_WALLPAPER_PATH; ignoring")
        return
    RUNTIME_DIR.mkdir(parents=True, exist_ok=True)
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    with LOCK_FILE.open("a", encoding="utf-8") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if is_music_selector(path):
            if remember_selector_event(path):
                return
            enter_music_mode()
            return
        if is_carousel_selector(path):
            if remember_selector_event(path):
                return
            enter_carousel_mode()
            return
        if consume_expected(path):
            if current_mode() in {"carousel", "normal"}:
                remember_normal(path)
            return
        # Also let users activate music mode by choosing the generated output.
        # Check pending internal wallpaper changes first, to avoid a hook loop.
        if same_path(path, MUSIC_CANONICAL):
            if remember_selector_event(path):
                return
            enter_music_mode()
            return
        mode = current_mode()
        if mode != "normal":
            log(f"Ordinary wallpaper selected; leaving {mode} mode")
            set_mode("normal")
            service("stop", MUSIC_SERVICE)
            service("stop", CAROUSEL_SERVICE)
        if not is_mode_wallpaper(path) and Path(path).expanduser().is_file():
            remember_normal(path)
            log(f"Saved normal wallpaper: {path}")


def screen_size() -> tuple[int, int]:
    result = run_command(["hyprctl", "monitors", "-j"], timeout=4.0)
    if result.returncode == 0:
        try:
            monitors = json.loads(result.stdout)
            usable = [
                item
                for item in monitors
                if int(item.get("width", 0)) > 0 and int(item.get("height", 0)) > 0
            ]
            if usable:
                monitor = max(
                    usable, key=lambda item: int(item["width"]) * int(item["height"])
                )
                width, height = int(monitor["width"]), int(monitor["height"])
                # Keep memory usage bounded on unusually high-resolution outputs.
                scale = min(1.0, 5120 / max(width, height))
                size = (max(640, int(width * scale)), max(360, int(height * scale)))
                try:
                    STATE_DIR.mkdir(parents=True, exist_ok=True)
                    SCREEN_SIZE_FILE.write_text(
                        json.dumps({"width": size[0], "height": size[1]}),
                        encoding="utf-8",
                    )
                except OSError:
                    pass
                return size
        except (ValueError, TypeError, KeyError, json.JSONDecodeError):
            pass
    # A systemd user service may not inherit Hyprland's per-process environment.
    # Reuse the dimensions last read by a Noctalia hook, which runs in the session.
    try:
        saved = json.loads(SCREEN_SIZE_FILE.read_text(encoding="utf-8"))
        width, height = int(saved["width"]), int(saved["height"])
        if width >= 640 and height >= 360:
            return width, height
    except (OSError, ValueError, TypeError, KeyError, json.JSONDecodeError):
        pass
    return 1920, 1080


def load_font(size: int) -> ImageFont.ImageFont:
    candidates = [
        os.environ.get("NOCTALIA_FONT_FILE", ""),
        "/run/current-system/sw/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/run/current-system/sw/share/X11/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/nix/store/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    for candidate in candidates:
        if not candidate:
            continue
        try:
            return ImageFont.truetype(candidate, size=size)
        except OSError:
            continue
    return ImageFont.load_default()


def save_image_atomic(image: Image.Image, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    temporary = destination.with_name(f".{destination.stem}.{os.getpid()}.tmp.png")
    image.save(temporary, format="PNG", optimize=True)
    temporary.replace(destination)


def download_artwork(url: str, signature: str) -> Image.Image | None:
    ART_CACHE_DIR.mkdir(parents=True, exist_ok=True)
    cache = ART_CACHE_DIR / f"{signature}.img"
    data: bytes | None = None
    if cache.is_file():
        try:
            data = cache.read_bytes()
        except OSError:
            data = None
    if data is None:
        try:
            if url.startswith("data:"):
                header, encoded = url.split(",", 1)
                data = (
                    base64.b64decode(encoded)
                    if ";base64" in header
                    else urllib.parse.unquote_to_bytes(encoded)
                )
            else:
                parsed = urllib.parse.urlparse(url)
                if not parsed.scheme and Path(url).is_file():
                    data = Path(url).read_bytes()
                else:
                    request: Any = (
                        urllib.request.Request(
                            url,
                            headers={
                                "User-Agent": "Mozilla/5.0 noctalia-music-wallpaper/1.0"
                            },
                        )
                        if parsed.scheme in {"http", "https"}
                        else url
                    )
                    with urllib.request.urlopen(request, timeout=12) as response:
                        data = response.read(25 * 1024 * 1024 + 1)
            if not data or len(data) > 25 * 1024 * 1024:
                log("Artwork is empty or larger than 25 MiB; skipping it")
                return None
            temporary = cache.with_suffix(".tmp")
            temporary.write_bytes(data)
            temporary.replace(cache)
        except (OSError, ValueError, urllib.error.URLError, TimeoutError) as error:
            log(f"Could not retrieve artwork ({url[:120]}): {error}")
            return None
    try:
        with Image.open(io.BytesIO(data)) as image:
            image.load()
            return ImageOps.exif_transpose(image).convert("RGB")
    except (OSError, ValueError) as error:
        log(f"Could not decode album artwork: {error}")
        return None


def compose_wallpaper(artwork: Image.Image) -> Image.Image:
    width, height = screen_size()
    background = ImageOps.fit(artwork, (width, height), method=Image.Resampling.LANCZOS)
    background = background.filter(
        ImageFilter.GaussianBlur(radius=max(18, int(min(width, height) * 0.035)))
    )
    # Dark overlay preserves desktop-widget and bar readability.
    overlay = Image.new("RGBA", (width, height), (5, 7, 15, 132))
    background = Image.alpha_composite(background.convert("RGBA"), overlay)

    cover_size = min(int(width * 0.36), int(height * 0.58))
    cover_size = max(260, cover_size)
    cover_size = min(cover_size, width - 100, height - 100)
    cover = ImageOps.fit(
        artwork, (cover_size, cover_size), method=Image.Resampling.LANCZOS
    ).convert("RGBA")
    radius = max(14, cover_size // 35)
    mask = Image.new("L", cover.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, cover_size - 1, cover_size - 1), radius=radius, fill=255
    )
    cover.putalpha(mask)

    x = (width - cover_size) // 2
    y = (height - cover_size) // 2
    shadow_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    shadow_mask = Image.new("L", (cover_size + 56, cover_size + 56), 0)
    ImageDraw.Draw(shadow_mask).rounded_rectangle(
        (24, 24, cover_size + 31, cover_size + 31), radius=radius + 4, fill=175
    )
    shadow_mask = shadow_mask.filter(
        ImageFilter.GaussianBlur(max(12, cover_size // 20))
    )
    shadow_layer.paste((0, 0, 0, 235), (x - 28, y - 28), shadow_mask)
    background = Image.alpha_composite(background, shadow_layer)

    border = Image.new("RGBA", (cover_size + 10, cover_size + 10), (0, 0, 0, 0))
    border_mask = Image.new("L", border.size, 0)
    ImageDraw.Draw(border_mask).rounded_rectangle(
        (0, 0, border.width - 1, border.height - 1), radius=radius + 2, fill=255
    )
    ImageDraw.Draw(border).rounded_rectangle(
        (0, 0, border.width - 1, border.height - 1),
        radius=radius + 2,
        fill=(255, 255, 255, 225),
    )
    background.alpha_composite(border, (x - 5, y - 5))
    background.alpha_composite(cover, (x, y))
    return background.convert("RGB")


def metadata(player: str, key: str) -> str:
    result = run_command(
        ["playerctl", "--player", player, "metadata", key], timeout=3.0
    )
    return result.stdout.strip() if result.returncode == 0 else ""


def active_playing_player() -> tuple[str, dict[str, str]] | None:
    result = run_command(["playerctl", "--list-all"], timeout=3.0)
    players = [line.strip() for line in result.stdout.splitlines() if line.strip()]

    def priority(player: str) -> tuple[int, str]:
        name = player.lower()
        if name == "spotify" or name.startswith("spotify."):
            return (0, name)
        if name.startswith("chromium"):
            return (1, name)
        return (2, name)

    for player in sorted(players, key=priority):
        status = run_command(["playerctl", "--player", player, "status"], timeout=2.0)
        if status.returncode != 0 or status.stdout.strip().lower() != "playing":
            continue
        data = {
            "art": metadata(player, "mpris:artUrl"),
            "trackid": metadata(player, "mpris:trackid"),
            "url": metadata(player, "xesam:url"),
            "artist": metadata(player, "xesam:artist") or metadata(player, "artist"),
            "title": metadata(player, "xesam:title") or metadata(player, "title"),
        }
        if not data["art"]:
            log(
                f"Player {player} is playing but did not publish mpris:artUrl; keeping current wallpaper"
            )
            continue
        data["player"] = player
        return player, data
    return None


def clean_render_cache(keep: int = 30) -> None:
    try:
        renders = sorted(
            RENDERS_DIR.glob("track-*.png"),
            key=lambda path: path.stat().st_mtime,
            reverse=True,
        )
        protected = last_music_render()
        removed = 0
        for path in renders:
            if len(renders) - removed <= keep or str(path) == protected:
                continue
            try:
                path.unlink()
                removed += 1
            except OSError:
                pass
    except OSError:
        pass


def clean_art_cache(keep: int = 50) -> None:
    try:
        files = sorted(
            ART_CACHE_DIR.glob("*.img"),
            key=lambda path: path.stat().st_mtime,
            reverse=True,
        )
        for path in files[keep:]:
            try:
                path.unlink()
            except OSError:
                pass
    except OSError:
        pass


def update_music_wallpaper(data: dict[str, str]) -> bool:
    identity = "\0".join(
        data.get(key, "")
        for key in ("player", "trackid", "url", "artist", "title", "art")
    )
    signature = hashlib.sha256(identity.encode("utf-8", "replace")).hexdigest()
    target = RENDERS_DIR / f"track-{signature[:24]}.png"
    RENDERS_DIR.mkdir(parents=True, exist_ok=True)

    if target.is_file():
        try:
            with Image.open(target) as image:
                image.load()
                rendered = image.convert("RGB")
        except OSError:
            target.unlink(missing_ok=True)
            rendered = None
    else:
        rendered = None

    if rendered is None:
        art = download_artwork(data["art"], signature)
        if art is None:
            return False
        rendered = compose_wallpaper(art)
        save_image_atomic(rendered, target)

    write_text_atomic(LAST_RENDER_FILE, str(target))
    if not set_wallpaper(target):
        return False
    log(
        f"Music wallpaper updated for {data.get('artist', 'Unknown artist')} — {data.get('title', 'Unknown track')} ({data.get('player', 'player')})"
    )
    clean_render_cache()
    clean_art_cache()
    return True


def music_monitor() -> None:
    log("Music wallpaper monitor started")
    last_attempted = ""
    while current_mode() == "music":
        selected = active_playing_player()
        if selected:
            player, data = selected
            identity = "\0".join(
                data.get(key, "")
                for key in ("player", "trackid", "url", "artist", "title", "art")
            )
            signature = hashlib.sha256(identity.encode("utf-8", "replace")).hexdigest()
            if signature != last_attempted:
                last_attempted = signature
                update_music_wallpaper(data)
        # No active player: deliberately leave the last generated wallpaper as-is.
        for _ in range(4):
            if current_mode() != "music":
                break
            time.sleep(0.5)
    log("Music wallpaper monitor stopped")


def ordinary_wallpapers() -> list[Path]:
    candidates: list[Path] = []
    if not WALLPAPER_DIR.is_dir():
        return candidates
    excluded_names = {MUSIC_SELECTOR.name, CAROUSEL_SELECTOR.name, MUSIC_CANONICAL.name}
    try:
        for path in WALLPAPER_DIR.rglob("*"):
            if (
                not path.is_file()
                or path.name in excluded_names
                or path.name.startswith(".00-music-theme")
            ):
                continue
            if path.suffix.lower() not in IMAGE_EXTENSIONS:
                continue
            if path.resolve(strict=False) in {
                MUSIC_SELECTOR.resolve(strict=False),
                CAROUSEL_SELECTOR.resolve(strict=False),
                MUSIC_CANONICAL.resolve(strict=False),
            }:
                continue
            candidates.append(path)
    except OSError as error:
        log(f"Could not scan wallpaper directory: {error}")
    return candidates


def apply_random_wallpaper() -> bool:
    candidates = ordinary_wallpapers()
    if not candidates:
        return False
    current = wallpaper_get()
    alternatives = [
        path for path in candidates if not current or not same_path(path, current)
    ]
    pool = alternatives or candidates
    target = random.choice(pool)
    remember_normal(target)
    return set_wallpaper(target)


def carousel_monitor() -> None:
    log(f"Carousel service started (interval {DEFAULT_INTERVAL}s)")
    while current_mode() == "carousel":
        for _ in range(DEFAULT_INTERVAL * 2):
            if current_mode() != "carousel":
                break
            time.sleep(0.5)
        if current_mode() == "carousel":
            if not apply_random_wallpaper():
                log("No ordinary wallpapers available; ending carousel mode")
                set_mode("normal")
                break
    log("Carousel service stopped")


def manual_status() -> None:
    print(f"Mode: {current_mode()}")
    print(f"Current Noctalia wallpaper: {wallpaper_get() or '(unavailable)'}")
    print(f"Last normal wallpaper: {last_normal() or '(not recorded)'}")
    print(f"Last music render: {last_music_render() or '(none yet)'}")
    print(f"Log: {LOG_FILE}")


def main() -> int:
    if len(sys.argv) != 2:
        print(
            "Usage: noctalia-music-wallpaper {startup|wallpaper-hook|music-monitor|carousel-monitor|status}",
            file=sys.stderr,
        )
        return 2
    command = sys.argv[1]
    if command == "startup":
        startup()
    elif command == "wallpaper-hook":
        wallpaper_hook()
    elif command == "music-monitor":
        music_monitor()
    elif command == "carousel-monitor":
        carousel_monitor()
    elif command == "status":
        manual_status()
    else:
        print(f"Unknown command: {command}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
