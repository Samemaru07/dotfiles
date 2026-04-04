#!/bin/bash
SOCKET=$(ls -t $XDG_RUNTIME_DIR/hypr/*/.socket2.sock 2>/dev/null | head -n1)

set_monitor() {
    local monitor=$1
    sed -i "s/:monitor \"GH-LCW24L\"/:monitor \"__TEMP__\"/g" ~/.config/eww/eww.yuck
    sed -i "s/:monitor \"PX248WAVE\"/:monitor \"__TEMP__\"/g" ~/.config/eww/eww.yuck
    sed -i "s/:monitor \"__TEMP__\"/:monitor \"$monitor\"/g" ~/.config/eww/eww.yuck
    eww reload
}

handle() {
    case $1 in
    "monitorremoved>>DP-1")
        eww close bar_widget
        sleep 0.5
        set_monitor "PX248WAVE"
        eww open bar_widget --screen PX248WAVE
        ;;
    "monitoradded>>DP-1")
        eww close bar_widget
        sleep 0.5
        set_monitor "GH-LCW24L"
        hyprctl dispatch moveworkspacetomonitor 1 DP-1
        hyprctl dispatch workspace 1
        sleep 0.3
        pkill -f asciiquarium
        pkill -f btop
        pkill -f clock.py
        sleep 0.2
        kitty --title aquarium --override window_padding_width=0 --override remember_window_size=no --override font_size=6 bash -c "asciiquarium" &
        kitty --title btop --override font_size=9 bash -c "btop" &
        kitty --title clock --config /home/samemaru/.config/hypr/scripts/clock-kitty.conf bash -c "python3 /home/samemaru/.config/hypr/scripts/clock.py" &
        eww open bar_widget --screen GH-LCW24L
        ;;
    esac
}

while read -r line; do
    handle "$line"
done < <(socat - UNIX-CONNECT:"$SOCKET")
