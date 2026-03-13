#!/bin/bash

BAT=$(ls /sys/class/power_supply/ 2>/dev/null | grep -i bat | head -1)

while true; do
    if [[ -z "$BAT" ]]; then
        echo ""
        sleep 5
        continue
    fi

    CHARGE_NOW=$(cat /sys/class/power_supply/$BAT/charge_now 2>/dev/null || echo 0)
    CURRENT_NOW=$(cat /sys/class/power_supply/$BAT/current_now 2>/dev/null || echo 0)
    CURRENT_NOW=${CURRENT_NOW#-}
    CHARGE_FULL=$(cat /sys/class/power_supply/$BAT/charge_full 2>/dev/null || echo 1)
    STATUS=$(cat /sys/class/power_supply/$BAT/status 2>/dev/null || echo "Unknown")

    if [ "$CURRENT_NOW" -ne 0 ]; then
        if [[ "$STATUS" == "Discharging" ]]; then
            MINUTES_LEFT=$(( CHARGE_NOW * 60 / CURRENT_NOW ))
            HOURS=$(( MINUTES_LEFT / 60 ))
            MINS=$(( MINUTES_LEFT % 60 ))
            echo "$HOURS h $MINS min left, $STATUS"
        elif [[ "$STATUS" == "Charging" ]]; then
            DIFF=$(( CHARGE_FULL - CHARGE_NOW ))
            MINUTES_TO_FULL=$(( DIFF * 60 / CURRENT_NOW ))
            HOURS=$(( MINUTES_TO_FULL / 60 ))
            MINS=$(( MINUTES_TO_FULL % 60 ))
            echo "$HOURS h $MINS min to full, $STATUS"
        else
            echo "0 h 0 min to full, $STATUS"
        fi
    else
        echo "$STATUS"
    fi
    sleep 1
done
