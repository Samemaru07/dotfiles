#!/bin/bash

if [[ -z $(eww active-windows | grep 'volctl') ]]; then
    /usr/bin/eww open volctl && /usr/bin/eww update volrev=true
else
    /usr/bin/eww update volrev=false
    (sleep 0.2 && /usr/bin/eww close volctl) &
fi
