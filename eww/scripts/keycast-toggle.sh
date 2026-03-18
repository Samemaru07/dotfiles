#!/bin/bash
if pgrep -f keycast.py >/dev/null; then
    pkill -f keycast.py
    eww close keycast
else
    python ~/.config/eww/eww-keycast/keycast.py &
fi
