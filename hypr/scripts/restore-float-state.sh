#!/bin/bash
# 復帰後：保存した状態に戻す
STATE_FILE=/tmp/hypr-float-state
[[ ! -f "$STATE_FILE" ]] && exit 0

sleep 2  # Hyprland復帰待ち

while IFS= read -r line; do
  ADDR=$(echo "$line" | awk '{print $1}')
  WS=$(echo "$line" | awk '{print $2}')
  [[ -z "$ADDR" || -z "$WS" ]] && continue
  hyprctl dispatch movetoworkspacesilent "${WS},address:${ADDR}"
done < "$STATE_FILE"

rm -f "$STATE_FILE"
