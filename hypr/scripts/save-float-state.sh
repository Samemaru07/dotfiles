#!/bin/bash
# スリープ前：フローティングウィンドウのアドレスとWSを保存
hyprctl clients -j | jq -r '
  .[] | select(.floating == true) |
  "\(.address) \(.workspace.id)"
' > /tmp/hypr-float-state
