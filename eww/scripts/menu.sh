#!/bin/bash

names=(
  "WezTerm"
  "Zen Browser"
  "Spotify"
  "Dolphin"
)

execs=(
  "wezterm"
  "zen-browser"
  "spotify"
  "dolphin"
)

icons=(
  "/usr/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png"
  "/usr/share/icons/hicolor/128x128/apps/zen-browser.png"
  "/usr/share/icons/hicolor/256x256/apps/spotify.png"
  "/usr/share/icons/hicolor/scalable/apps/org.kde.dolphin.svg"
)

terminal=(
  false
  false
  false
  false
)

json="["

for i in "${!names[@]}"; do
  [[ $i -ne 0 ]] && json+=","
  json+="{\"name\":\"${names[$i]}\",\"exec\":\"${execs[$i]}\",\"icon\":\"${icons[$i]}\",\"terminal\":\"${terminal[$i]}\"}"
done

json+="]"
echo "$json"
