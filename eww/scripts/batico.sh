#!/bin/bash

BAT=$(ls /sys/class/power_supply/ 2>/dev/null | grep -i bat | head -1)

get_icon(){
  case $1 in
    9[0-9]|100) CLASS="BAT1"; ICON=" " ;;
    8[0-9]|7[0-9]|6[5-9]) CLASS="BAT2"; ICON=" " ;;
    6[0-4]|5[0-9]|4[5-9]) CLASS="BAT3"; ICON=" " ;;
    4[0-4]|3[0-9]|2[0-9]|1[5-9]) CLASS="BAT4"; ICON=" " ;;
    *) CLASS="BAT5"; ICON=" " ;;
  esac
}

while true; do
    if [[ -z "$BAT" ]]; then
        echo "(box \"\")"
        sleep 5
        continue
    fi

    BATTERY=$(cat /sys/class/power_supply/$BAT/capacity 2>/dev/null || echo 0)
    STATUS=$(cat /sys/class/power_supply/$BAT/status 2>/dev/null || echo "Unknown")
    CLASS=""
    ICON=""
    get_icon "$BATTERY"

    if [[ "$STATUS" == "Charging" ]]; then
        CLASS="CHARGING"
    fi

    echo "(box :class \"$CLASS\" \"$ICON\")"
    sleep 1
done
