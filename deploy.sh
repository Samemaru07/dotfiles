#!/bin/bash
DOTFILES_DIR="$HOME/dotfiles"
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
sudo ln -snf "$DOTFILES_DIR/sddm/Sugar-Candy/theme.conf" "/usr/share/sddm/themes/Sugar-Candy/theme.conf"
sudo ln -snf "$DOTFILES_DIR/assets/lock/angel.png" "/usr/share/sddm/Sugar-Candy/Backgrounds/angel.png"

mkdir -p "$HOME/.config/hypr/scripts"
ln -snf "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
ln -snf "$DOTFILES_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
ln -snf "$DOTFILES_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
ln -snf "$DOTFILES_DIR/hypr/scripts/clock-kitty.conf" "$HOME/.config/hypr/scripts/clock-kitty.conf"
ln -snf "$DOTFILES_DIR/hypr/scripts/clock.py" "$HOME/.config/hypr/scripts/clock.py"
ln -snf "$DOTFILES_DIR/hypr/scripts/monitor-watch.sh" "$HOME/.config/hypr/scripts/monitor-watch.sh"
ln -snf "$DOTFILES_DIR/hypr/scripts/photo-widget.sh" "$HOME/.config/hypr/scripts/monitor-watch.sh"

mkdir -p "$HOME/.config/eww/scripts"
ln -snf "$DOTFILES_DIR/eww/eww.scss" "$HOME/.config/eww/eww.scss"
ln -snf "$DOTFILES_DIR/eww/eww.yuck" "$HOME/.config/eww/eww.yuck"
for f in "$DOTFILES_DIR/eww/scripts/"*; do 
    ln -snf "$f" "$HOME/.config/eww/scripts/$(basename "$f")"
done
