#!/bin/bash
SOCKET=$(ls -t $XDG_RUNTIME_DIR/hypr/*/.socket2.sock 2>/dev/null | head -n1)

socat - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    echo "$line" >> /tmp/spotify-watch.log
    case $line in
        "fullscreen>>0"*)
            active=$(hyprctl activewindow -j | jq -r '.class')
            echo "active: $active" >> /tmp/spotify-watch.log
            if [[ "$active" =~ [Ss]potify ]]; then
                sleep 0.1
                hyprctl dispatch setfloating 'class:^([Ss]potify)$'
                hyprctl dispatch movewindowpixel 'exact 10 55,class:^([Ss]potify)$'
                hyprctl dispatch resizewindowpixel 'exact 850 700,class:^([Ss]potify)$'
            fi
            ;;
    esac
done
