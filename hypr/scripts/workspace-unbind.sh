#!/bin/bash
SOCKET=$(ls -t $XDG_RUNTIME_DIR/hypr/*/.socket2.sock 2>/dev/null | head -n1)

# 初期状態
current=$(hyprctl activeworkspace -j | jq -r '.id')
if [[ "$current" == "1" ]]; then
    hyprctl keyword unbind "SUPER, mouse:272"
    hyprctl keyword unbind "SUPER, mouse:273"
    hyprctl keyword general:resize_on_border false
else
    hyprctl keyword bindm "SUPER, mouse:272, movewindow"
    hyprctl keyword bindm "SUPER, mouse:273, resizewindow"
    hyprctl keyword general:resize_on_border true
fi

socat -u UNIX-CONNECT:"$SOCKET" - | while read -r line; do
    case $line in
        "workspace>>1"|"focusedmon>>DP-1,1")
            hyprctl keyword unbind "SUPER, mouse:272"
            hyprctl keyword unbind "SUPER, mouse:273"
            hyprctl keyword general:resize_on_border false
            ;;
        "workspace>>"*|"focusedmon>>DP-"*)
            hyprctl keyword bindm "SUPER, mouse:272, movewindow"
            hyprctl keyword bindm "SUPER, mouse:273, resizewindow"
            hyprctl keyword general:resize_on_border true
            ;;
    esac
done
