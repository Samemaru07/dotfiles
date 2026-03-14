#!/bin/bash
eww daemon
# デーモンが起動するまで待つ
while ! eww ping 2>/dev/null; do
    sleep 0.1
done
eww open bar_widget --screen GH-LCW24L
bash ~/.config/eww/scripts/workspace.sh &
