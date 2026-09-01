#!/usr/bin/env bash
if hyprctl clients -j | jq -e '.[] | select(.class == "org.pulseaudio.pavucontrol")' >/dev/null; then
    hyprctl dispatch closewindow "class:^(org.pulseaudio.pavucontrol)\$"
else
    pavucontrol &
fi
