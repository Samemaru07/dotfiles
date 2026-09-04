#!/bin/bash

if [ "$CHEZMOI_OS_RELEASE_ID" = "arch" ]; then
    sudo pacman -S --needed --noconfirm hyprland hypridle hyprpaper waybar wofi wlogout swaync sddm fcitx5-im fcitx5-skk networkmanager cava kitty tmux btop lazygit wl-clipboard jq less gvfs grim slurp xdg-user-dirs feh biber ttf-jetbrains-mono-nerd noto-fonts-cjk noto-fonts-emoji

    yay -S --needed --noconfirm quickshell openrgb zen-browser-bin

    xdg-user-dirs-update
    mkdir -p ~/Pictures/Screenshots
fi
