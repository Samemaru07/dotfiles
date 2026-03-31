#!/bin/bash

hyprctl dispatch movecursor 2880 540

MONITOR_COUNT=$(hyprctl monitors | grep -c "^Monitor")
export BRUNHILDE_MONITOR=$MONITOR_COUNT

swaybg -i /home/samemaru/dotfiles/assets/home/fafner.jpeg -m fill &
sleep 1
if [ ! -f /tmp/brunhilde_booted ]; then
    hyprctl dispatch submap locked
    BRUNHILDE_MONITOR=$MONITOR_COUNT /usr/local/bin/processing-java --sketch=/home/samemaru/project/boot_animation/brunhilde_system --run
    hyprctl dispatch submap reset
    touch /tmp/brunhilde_booted
fi

systemctl --user import-environment WAYLAND_DISPLAY XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE
bash /home/samemaru/.config/eww/scripts/eww-start.sh
dunst &
fcitx5 -d &
kitty --title cava bash -c "cava" &
spotify &
kitty --title clock --config /home/samemaru/.config/hypr/scripts/clock-kitty.conf bash -c "sleep 1; python3 /home/samemaru/.config/hypr/scripts/clock.py" &
kitty --title aquarium --override window_padding_width=0 --override remember_window_size=no --override font_size=6 bash -c "sleep 1; asciiquarium" &
bash /home/samemaru/.config/hypr/scripts/photo-widget.sh photo1 /home/samemaru/dotfiles/assets/widget/maya.PNG 220 180 8 &
bash /home/samemaru/.config/hypr/scripts/photo-widget.sh photo2 /home/samemaru/dotfiles/assets/widget/suremio.JPG 220 180 8 &
bash /home/samemaru/.config/hypr/scripts/monitor-watch.sh &
kitty --title btop --override font_size=9 bash -c "sleep 1; btop" &
bash /home/samemaru/.config/hypr/scripts/spotify-watch.sh &
bash /home/samemaru/.config/hypr/scripts/workspace-unbind.sh &
quickshell -c qs-hyprview &
pactl set-sink-port alsa_output.pci-0000_0c_00.4.analog-stereo analog-output-lineout &
openrgb --profile Ares --startminimized &
hypridle &
