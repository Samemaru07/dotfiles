#!/bin/bash
DOTFILES_DIR="/home/samemaru/dotfiles"
ln -snf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -snf "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -snf "$DOTFILES_DIR/shell/.profile" "$HOME/.profile"
ln -snf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config"
ln -snf "$DOTFILES_DIR/wezterm/.config/wezterm" "$HOME/.config/wezterm"
ln -snf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
ln -snf "$DOTFILES_DIR/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
mkdir -p "$HOME/.config/fastfetch"
ln -snf "$DOTFILES_DIR/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
mkdir -p "$HOME/.local/share/applications"
ln -snf "$DOTFILES_DIR/applications/org.wezfurlong.wezterm.desktop" "$HOME/.local/share/applications/org.wezfurlong.wezterm.desktop"
mkdir -p "$HOME/.config/wofi"
ln -snf "$DOTFILES_DIR/wofi/config" "$HOME/.config/wofi/config"
ln -snf "$DOTFILES_DIR/wofi/style.css" "$HOME/.config/wofi/style.css"
# SKK (Arch Linux only; skip on WSL/Ubuntu)
if ! grep -qi microsoft /proc/version 2>/dev/null; then
    mkdir -p "$HOME/.config/libskk/rules/myrule/keymap"
    ln -snf "$DOTFILES_DIR/skk/metadata.json" "$HOME/.config/libskk/rules/myrule/metadata.json"
    ln -snf "$DOTFILES_DIR/skk/keymap/hiragana.json" "$HOME/.config/libskk/rules/myrule/keymap/hiragana.json"
    ln -snf "$DOTFILES_DIR/skk/keymap/katakana.json" "$HOME/.config/libskk/rules/myrule/keymap/katakana.json"
fi
sudo mkdir -p "/etc/sddm.conf.d"
sudo ln -snf "$DOTFILES_DIR/sddm/theme.conf" "/etc/sddm.conf.d/theme.conf"
if [ -d "/usr/share/sddm/themes/Sugar-Candy" ]; then
    sudo ln -snf "$DOTFILES_DIR/sddm/Sugar-Candy/theme.conf" "/usr/share/sddm/themes/Sugar-Candy/theme.conf"
    sudo ln -snf "$DOTFILES_DIR/assets/lock/angel.png" "/usr/share/sddm/themes/Sugar-Candy/Backgrounds/angel.png"
fi

mkdir -p "$HOME/.config/hypr/scripts"
ln -snf "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
ln -snf "$DOTFILES_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
ln -snf "$DOTFILES_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
ln -snf "$DOTFILES_DIR/hypr/scripts/clock-kitty.conf" "$HOME/.config/hypr/scripts/clock-kitty.conf"
ln -snf "$DOTFILES_DIR/hypr/scripts/clock.py" "$HOME/.config/hypr/scripts/clock.py"
ln -snf "$DOTFILES_DIR/hypr/scripts/monitor-watch.sh" "$HOME/.config/hypr/scripts/monitor-watch.sh"
ln -snf "$DOTFILES_DIR/hypr/scripts/photo-widget.sh" "$HOME/.config/hypr/scripts/photo-widget.sh"
ln -snf "$DOTFILES_DIR/hypr/scripts/spotify-watch.sh" "$HOME/.config/hypr/scripts/spotify-watch.sh"
ln -snf "$DOTFILES_DIR/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
ln -snf "$DOTFILES_DIR/hypr/scripts/save-float-state.sh" "$HOME/.config/hypr/scripts/save-float-state.sh"
ln -snf "$DOTFILES_DIR/hypr/scripts/restore-float-state.sh" "$HOME/.config/hypr/scripts/restore-float-state.sh"

mkdir -p "$HOME/.config/eww/scripts"
ln -snf "$DOTFILES_DIR/eww/eww.scss" "$HOME/.config/eww/eww.scss"
ln -snf "$DOTFILES_DIR/eww/eww.yuck" "$HOME/.config/eww/eww.yuck"
for f in "$DOTFILES_DIR/eww/scripts/"*; do
    ln -snf "$f" "$HOME/.config/eww/scripts/$(basename "$f")"
done

mkdir -p "$HOME/.config/quickshell/qs-hyprview/modules"
ln -snf "$DOTFILES_DIR/quickshell/qs-hyprview/shell.qml" "$HOME/.config/quickshell/qs-hyprview/shell.qml"
ln -snf "$DOTFILES_DIR/quickshell/qs-hyprview/modules/Hyprview.qml" "$HOME/.config/quickshell/qs-hyprview/modules/Hyprview.qml"
mkdir -p "$HOME/.config/quickshell/qs-hyprview/layouts"
ln -snf "$DOTFILES_DIR/quickshell/qs-hyprview/layouts/MasonryLayout.qml" "$HOME/.config/quickshell/qs-hyprview/layouts/MasonryLayout.qml"
ln -snf "$DOTFILES_DIR/quickshell/qs-hyprview/layouts/ColumnarLayout.qml" "$HOME/.config/quickshell/qs-hyprview/layouts/ColumnarLayout.qml"

mkdir -p "/etc/NetworkManager/"
sudo ln -snf "$DOTFILES_DIR/etc/NetworkManager/NetworkManager.conf" "/etc/NetworkManager/NetworkManager.conf"

mkdir -p "$HOME/.config/fcitx5/conf"
ln -snf "$DOTFILES_DIR/fcitx5/conf/keyboard.conf" "$HOME/.config/fcitx5/conf/keyboard.conf"
ln -snf "$DOTFILES_DIR/fcitx5/conf/notificationitem.conf" "$HOME/.config/fcitx5/conf/notificationitem.conf"
ln -snf "$DOTFILES_DIR/fcitx5/conf/notifications.conf" "$HOME/.config/fcitx5/conf/notifications.conf"
ln -snf "$DOTFILES_DIR/fcitx5/conf/skk.conf" "$HOME/.config/fcitx5/conf/skk.conf"
ln -snf "$DOTFILES_DIR/fcitx5/config" "$HOME/.config/fcitx5/config"
ln -snf "$DOTFILES_DIR/fcitx5/profile" "$HOME/.config/fcitx5/profile"
