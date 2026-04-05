#!/bin/bash
ID="$1"
CACHE="$HOME/.cache/eww-notifications.json"

# swayncから削除
gdbus call --session \
    --dest org.erikreider.swaync \
    --object-path /org/erikreider/swaync/cc \
    --method org.erikreider.swaync.cc.CloseNotification \
    "uint32 $ID" >/dev/null 2>&1

# JSONからも削除
jq "map(select(.id != \"$ID\))" "$CACHE" >"$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
