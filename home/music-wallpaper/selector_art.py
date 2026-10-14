#!/usr/bin/env python3
"""Build attractive placeholder images for Noctalia's wallpaper selector."""
import os
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

OUT = Path(sys.argv[1])
OUT.mkdir(parents=True, exist_ok=True)
W, H = 1600, 900
FONT_CANDIDATES = [
    os.environ.get("NOCTALIA_FONT_FILE", ""),
    "/run/current-system/sw/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    "/run/current-system/sw/share/X11/fonts/truetype/dejavu/DejaVuSans.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
]

def font(size):
    for candidate in FONT_CANDIDATES:
        if not candidate:
            continue
        try:
            return ImageFont.truetype(candidate, size=size)
        except OSError:
            pass
    return ImageFont.load_default()

def make(path, title, subtitle, colors, icon):
    image = Image.new("RGB", (W, H))
    pixels = image.load()
    for y in range(H):
        for x in range(W):
            fx, fy = x / W, y / H
            glow = max(0, 1 - (((fx - .70) / .75) ** 2 + ((fy - .27) / .9) ** 2))
            glow2 = max(0, 1 - (((fx - .18) / .62) ** 2 + ((fy - .85) / .8) ** 2))
            pixels[x, y] = tuple(max(0, min(255, int(colors[0][c] + (colors[1][c] - colors[0][c]) * glow + (colors[2][c] - colors[0][c]) * glow2))) for c in range(3))
    glow_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow_layer)
    gd.ellipse((W * .48, -H * .45, W * 1.1, H * .6), fill=(*colors[1], 90))
    gd.ellipse((-W * .2, H * .55, W * .55, H * 1.3), fill=(*colors[2], 70))
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(110))
    image = Image.alpha_composite(image.convert("RGBA"), glow_layer)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((95, 95, W - 95, H - 95), radius=38, outline=(255, 255, 255, 42), width=2, fill=(5, 7, 18, 85))
    center_x, center_y = W // 2, H // 2 - 72
    draw.ellipse((center_x - 112, center_y - 112, center_x + 112, center_y + 112), fill=(*colors[1], 45), outline=(*colors[1], 180), width=3)
    f_icon = font(104)
    draw.text((center_x, center_y - 9), icon, anchor="mm", font=f_icon, fill=(246, 245, 255, 255))
    draw.text((center_x, H * .68), title, anchor="mm", font=font(68), fill=(248, 247, 255, 255))
    draw.text((center_x, H * .77), subtitle, anchor="mm", font=font(27), fill=(190, 192, 215, 255))
    draw.rounded_rectangle((center_x - 90, H * .84, center_x + 90, H * .84 + 7), radius=4, fill=(*colors[1], 220))
    image.convert("RGB").save(path, format="PNG", optimize=True)

make(OUT / "00-music-theme.png", "MUSIC MODE", "ALBUM ART  ·  BLURRED AMBIENT WALLPAPER", ((9, 12, 28), (115, 67, 188), (29, 148, 172)), "♫")
make(OUT / "01-carroussel.png", "CARROUSSEL", "AUTOMATIC WALLPAPER ROTATION", ((8, 18, 24), (28, 154, 165), (88, 106, 190)), "↻")
