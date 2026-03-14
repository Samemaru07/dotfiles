#!/bin/bash

IM=$(fcitx5-remote -n 2>/dev/null)

case "$IM" in
    skk)           MODE="あ" ;;
    keyboard-us)   MODE="A" ;;
    keyboard-*)    MODE="A" ;;
    *)             MODE="A" ;;
esac

# Caps Lock via hyprctl
CAPS=$(hyprctl devices -j 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
for kb in d.get('keyboards',[]):
    if kb.get('capsLock'):
        print('true')
        exit()
print('false')
")

echo "{\"mode\": \"$MODE\", \"caps\": $CAPS}"
