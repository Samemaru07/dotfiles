#!/bin/bash
# $1: title (photo1 or photo2)
# $2: source image path
# $3: x offset for crop (default: 86 = center for 453px wide image)

TITLE="$1"
SRC="$2"
OFFSET="${3:-86}"
TMP="/tmp/${TITLE}_widget.png"

magick "$SRC" -resize x290 -gravity None -crop 280x290+${OFFSET}+0 +repage "$TMP"
feh --title "$TITLE" --borderless --no-menus "$TMP"
