#!/bin/bash

if [[ -z $(eww active-windows | grep 'usrctl') ]]; then
    /usr/bin/eww update music_ready=false
    /usr/bin/eww open usrctl && /usr/bin/eww update ctlrev=true
    (sleep 0.5 && /usr/bin/eww update music_ready=true) &
else
    /usr/bin/eww update ctlrev=false
    /usr/bin/eww update music_ready=false
    (sleep 0.2 && /usr/bin/eww close usrctl) &
fi
