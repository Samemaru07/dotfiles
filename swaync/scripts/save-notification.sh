#!/bin/bash
CACHE="$HOME/.cache/eww-notifications.json"

[ ! -f "$CACHE" ] && echo "[]" >"$CACHE"

NEW_ENTRY=$(
    jq -n \
        --arg id "$SWAYNC_ID" \
        --arg app "$SWAYNC_APP_NAME" \
        --arg summary "$SWAYNC_SUMMARY" \
        --arg body "$SWAYNC_BODY" \
        --arg urgency "$SWAYNC_URGENCY" \
        --arg time "$SWAYNC_TIME" \
        '{id: $id, app: $app, summary: $summary, body: $body, urgency: $urgency, time: $time}'
)

jq ". + [$NEW_ENTRY]" "$CACHE" >"$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
