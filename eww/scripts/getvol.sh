#!/bin/bash

vol=$(pamixer --get-volume)
mute=$(pamixer --get-mute)
if [ "$mute" = true ]; then
    /usr/bin/eww update volico="󰖁"
    echo "0"
else
    /usr/bin/eww update volico="󰕾"
    echo "$vol"
fi

LANG=C pactl subscribe | stdbuf -oL grep --line-buffered "Event 'change' on sink" | while read -r _; do
    vol=$(pamixer --get-volume)
    mute=$(pamixer --get-mute)
    if [ "$mute" = true ]; then
        /usr/bin/eww update volico="󰖁"
        echo "0"
    else
        /usr/bin/eww update volico="󰕾"
        echo "$vol"
    fi
done
