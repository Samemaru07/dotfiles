#!/bin/bash
TITLE="$1"
SRC="$2"
WIDTH="${3:-120}"
HEIGHT="${4:-120}"
OFFSET="${5:-0}"
TMP="/tmp/${TITLE}_widget.png"
magick "$SRC" -resize ${WIDTH}x${HEIGHT}^ -gravity Center -crop ${WIDTH}x${HEIGHT}+${OFFSET}+0 +repage "$TMP"
feh --title "$TITLE" --borderless --no-menus "$TMP"
