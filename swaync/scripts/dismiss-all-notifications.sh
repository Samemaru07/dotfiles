#!/bin/bash
CACHE="$HOME/.cache/eww-notifications.json"

# swayncから全削除
gdbus call --session \
    --dest org.erikreider.swaync \
    --object-path /org/erikreider/swaync/cc \
    --method org.erikreider.swaync.cc.CloseAllNotifications >&/dev/null

# JSONも全削除
echo "[]" >"$CACHE"
