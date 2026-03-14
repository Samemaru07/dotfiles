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
            eww open bar_widget --screen GH-LCW24L
            ;;
    esac
}

socat - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    handle "$line"
done
