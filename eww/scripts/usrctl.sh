#!/bin/bash
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ "$ACTIVE_MONITOR" = "DP-1" ]; then
    WINDOW="usrctl"
    VAR="ctlrev"
else
    WINDOW="usrctl_sub"
    VAR="ctlrev_sub"
fi

if [[ -z $(eww active-windows | grep "$WINDOW") ]]; then
    /usr/bin/eww update music_ready=false
    /usr/bin/eww open "$WINDOW" && /usr/bin/eww update ${VAR}=true
    (sleep 0.5 && /usr/bin/eww update music_ready=true) &
else
    /usr/bin/eww update ${VAR}=false
    /usr/bin/eww update music_ready=false
    (sleep 0.2 && /usr/bin/eww close "$WINDOW") &
fi
