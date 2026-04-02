#!/bin/bash
eww daemon
# デーモンが起動するまで待つ
while ! eww ping 2>/dev/null; do
    sleep 0.1
done
# 起動時の実際のメインモニターを取得
#
if hyprctl monitors | grep -q "DP-1"; then
    SCREEN="GH-LCW24L"
else
    SCREEN="PX248WAVE"
fi

# eww.yuckのモニター設定を合わせる（volctl等のoverlay系も含む）
sed -i "s/:monitor \"GH-LCW24L\"/:monitor \"__TEMP__\"/g" ~/.config/eww/eww.yuck
sed -i "s/:monitor \"PX248WAVE\"/:monitor \"__TEMP__\"/g" ~/.config/eww/eww.yuck
sed -i "s/:monitor \"__TEMP__\"/:monitor \"$SCREEN\"/g" ~/.config/eww/eww.yuck

eww open bar_widget --screen "$SCREEN"
bash ~/.config/eww/scripts/workspace.sh &
