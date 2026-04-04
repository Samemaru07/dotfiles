#!/bin/bash
eww daemon
while ! eww ping 2>/dev/null; do
    sleep 0.1
done

eww open bar_widget --screen GH-LCW24L
eww open bar_widget_sub --screen PX248WAVE
bash ~/.config/eww/scripts/workspace.sh &
