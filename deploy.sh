#!/bin/bash
HOME_DIR="/home/samemaru"
DOTFILES_DIR="/home/samemaru/dotfiles"
ln -snf "$DOTFILES_DIR/zsh/.zshrc" "$HOME_DIR/.zshrc"
ln -snf "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME_DIR/.tmux.conf"
ln -snf "$DOTFILES_DIR/shell/.profile" "$HOME_DIR/.profile"
ln -snf "$DOTFILES_DIR/git/.gitconfig" "$HOME_DIR/.gitconfig"
mkdir -p "$HOME_DIR/.config"
ln -snf "$DOTFILES_DIR/wezterm" "$HOME_DIR/.config/wezterm"
ln -snf "$DOTFILES_DIR/.config/nvim" "$HOME_DIR/.config/nvim"
ln -snf "$DOTFILES_DIR/p10k/.p10k.zsh" "$HOME_DIR/.p10k.zsh"
mkdir -p "$HOME_DIR/.config/fastfetch"
ln -snf "$DOTFILES_DIR/fastfetch/config.jsonc" "$HOME_DIR/.config/fastfetch/config.jsonc"
mkdir -p "$HOME_DIR/.local/share/applications"
ln -snf "$DOTFILES_DIR/applications/org.wezfurlong.wezterm.desktop" "$HOME_DIR/.local/share/applications/org.wezfurlong.wezterm.desktop"
mkdir -p "$HOME_DIR/.config/wofi"
ln -snf "$DOTFILES_DIR/wofi/config" "$HOME_DIR/.config/wofi/config"
ln -snf "$DOTFILES_DIR/wofi/style.css" "$HOME_DIR/.config/wofi/style.css"
# SKK (Arch Linux only; skip on WSL/Ubuntu)
if ! grep -qi microsoft /proc/version 2>/dev/null; then
    mkdir -p "$HOME_DIR/.config/libskk/rules/myrule/keymap"
    ln -snf "$DOTFILES_DIR/skk/metadata.json" "$HOME_DIR/.config/libskk/rules/myrule/metadata.json"
    ln -snf "$DOTFILES_DIR/skk/keymap/hiragana.json" "$HOME_DIR/.config/libskk/rules/myrule/keymap/hiragana.json"
    ln -snf "$DOTFILES_DIR/skk/keymap/katakana.json" "$HOME_DIR/.config/libskk/rules/myrule/keymap/katakana.json"
fi
sudo mkdir -p "/etc/sddm.conf.d"
sudo ln -snf "$DOTFILES_DIR/sddm/theme.conf" "/etc/sddm.conf.d/theme.conf"
if [ -d "/usr/share/sddm/themes/Sugar-Candy" ]; then
    sudo ln -snf "$DOTFILES_DIR/sddm/Sugar-Candy/theme.conf" "/usr/share/sddm/themes/Sugar-Candy/theme.conf"
    sudo ln -snf "$DOTFILES_DIR/assets/lock/angel.png" "/usr/share/sddm/themes/Sugar-Candy/Backgrounds/angel.png"
fi

mkdir -p "$HOME_DIR/.config/hypr/scripts"
for f in "$DOTFILES_DIR/hypr/"*.conf; do
    ln -snf "$f" "$HOME_DIR/.config/hypr/$(basename "$f")"
done
for f in "$DOTFILES_DIR/hypr/scripts/"*; do
    ln -snf "$f" "$HOME_DIR/.config/hypr/scripts/$(basename "$f")"
done

mkdir -p "$HOME_DIR/.config/eww/scripts"
ln -snf "$DOTFILES_DIR/eww/eww.scss" "$HOME_DIR/.config/eww/eww.scss"
ln -snf "$DOTFILES_DIR/eww/eww.yuck" "$HOME_DIR/.config/eww/eww.yuck"
for f in "$DOTFILES_DIR/eww/scripts/"*; do
    ln -snf "$f" "$HOME_DIR/.config/eww/scripts/$(basename "$f")"
done

QS_SRC="$DOTFILES_DIR/quickshell/qs-hyprview"
QS_DST="$HOME_DIR/.config/quickshell/qs-hyprview"
for dir in "" modules layouts; do
    mkdir -p "$QS_DST/$dir"
    for f in "$QS_SRC/$dir/"*.qml; do
        [ -f "$f" ] || continue
        ln -snf "$f" "$QS_DST/$dir/$(basename "$f")"
    done
done

mkdir -p "/etc/NetworkManager/"
sudo ln -snf "$DOTFILES_DIR/etc/NetworkManager/NetworkManager.conf" "/etc/NetworkManager/NetworkManager.conf"

mkdir -p "$HOME_DIR/.config/fcitx5/conf"
for f in "$DOTFILES_DIR/fcitx5/conf/"*.conf; do
    ln -snf "$f" "$HOME_DIR/.config/fcitx5/conf/$(basename "$f")"
done
ln -snf "$DOTFILES_DIR/fcitx5/config" "$HOME_DIR/.config/fcitx5/config"
ln -snf "$DOTFILES_DIR/fcitx5/profile" "$HOME_DIR/.config/fcitx5/profile"
