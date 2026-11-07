#!/usr/bin/env python3
"""Reset Noctalia GUI overrides while preserving active wallpapers."""

import json
import os
import sys
import tempfile
import tomllib
from pathlib import Path


def restore(settings_file: Path) -> None:
    settings_file.parent.mkdir(parents=True, exist_ok=True)

    data = (
        tomllib.loads(settings_file.read_text(encoding="utf-8"))
        if settings_file.exists()
        else {}
    )

    wallpaper = data.get("wallpaper", {})
    lines = []

    def preserve(section: str, entry: dict) -> None:
        if not isinstance(entry, dict):
            return

        path = entry.get("path")
        if isinstance(path, str) and path:
            lines.extend([
                f"[{section}]",
                f"path = {json.dumps(path, ensure_ascii=False)}",
                "",
            ])

    for name in ("default", "last"):
        preserve(f"wallpaper.{name}", wallpaper.get(name))

    for monitor, entry in sorted(wallpaper.get("monitors", {}).items()):
        preserve(f"wallpaper.monitors.{json.dumps(monitor, ensure_ascii=False)}", entry)

    fd, temporary = tempfile.mkstemp(
        prefix=".settings.toml.",
        dir=settings_file.parent,
    )

    try:
        with os.fdopen(fd, "w", encoding="utf-8") as file:
            file.write("\n".join(lines))

        os.chmod(temporary, 0o600)
        os.replace(temporary, settings_file)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


if __name__ == "__main__":
    restore(Path(sys.argv[1]))
