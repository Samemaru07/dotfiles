#!/bin/bash
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ "$ACTIVE_MONITOR" = "DP-1" ]; then
    WINDOW="wifictl"
    VAR="wifictlrev"
else
    WINDOW="wifictl_sub"
    VAR="wifictlrev_sub"
fi

if [[ -z $(eww active-windows | grep "$WINDOW") ]]; then
    /usr/bin/eww open "$WINDOW" && /usr/bin/eww update ${VAR}=true
else
    /usr/bin/eww update ${VAR}=false && /usr/bin/eww update wificonfigrev=false
    (sleep 0.2 && /usr/bin/eww close "$WINDOW") &
fi
