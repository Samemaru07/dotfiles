#!/bin/bash
selected=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id != 1) | select(.title != "ピクチャーインピクチャー") | "\(.title) (\(.address))\u0000icon\u001f\(if .class == "zen" then "zen-browser" else .class end)"' | rofi -dmenu -show-icons -theme ~/.config/rofi/themes/main.rasi)

address=$(echo "$selected" | grep -oP '\(0x[0-9a-f]+\)' | tr -d '()')
if [ -n "$address" ]; then
    coords=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | \"\(.at[0]+(.size[0]/2|floor)) \(.at[1]+(.size[1]/2|floor))\"")
    hyprctl dispatch focuswindow "address:$address"
    hyprctl dispatch movecursor $coords
fi
