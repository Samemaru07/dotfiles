#!/bin/bash

set -e

HOME_DIR="$(cd ~ && pwd)"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ============================================================
# 実行環境の判定
# ============================================================
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
else
    IS_WSL=false
fi

# ============================================================
# ヘルパー関数
# ============================================================

# ディレクトリを作成してシンボリックリンクを貼る
# 使い方: link <リンク元(dotfiles側)> <リンク先(HOME側)>
link() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    ln -snf "$src" "$dst"
}

# ディレクトリ内のファイルを一括リンク（サブディレクトリは対象外）
# 使い方: link_dir <リンク元ディレクトリ> <リンク先ディレクトリ> [拡張子フィルタ(例: "*.conf")]
link_dir() {
    local src_dir="$1"
    local dst_dir="$2"
    local pattern="${3:-*}"
    mkdir -p "$dst_dir"
    for f in "$src_dir"/$pattern; do
        [ -f "$f" ] || continue
        ln -snf "$f" "$dst_dir/$(basename "$f")"
    done
}

# ============================================================
# WSL / 共通設定
# ============================================================

# シェル・ターミナル基本設定
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME_DIR/.zshrc"
link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME_DIR/.tmux.conf"
link "$DOTFILES_DIR/shell/.profile" "$HOME_DIR/.profile"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME_DIR/.gitconfig"
link "$DOTFILES_DIR/p10k/.p10k.zsh" "$HOME_DIR/.p10k.zsh"

# WezTerm
WIN_USER=$(ls /mnt/c/Users/ | grep -v -E 'All Users|Default|Public|desktop.ini')
WIN_WEZTERM_DIR="/mnt/c/Users/$WIN_USER/.config/wezterm"
rm -rf "$WIN_WEZTERM_DIR"
mkdir -p "$WIN_WEZTERM_DIR"
cp "$DOTFILES_DIR/wezterm/"* "$WIN_WEZTERM_DIR/"

# Neovim (git submodule)
link "$DOTFILES_DIR/nvim" "$HOME_DIR/.config/nvim"

# fastfetch
link "$DOTFILES_DIR/fastfetch/config.jsonc" "$HOME_DIR/.config/fastfetch/config.jsonc"

# .desktop ファイル
link "$DOTFILES_DIR/applications/org.wezfurlong.wezterm.desktop" \
    "$HOME_DIR/.local/share/applications/org.wezfurlong.wezterm.desktop"

# .clang-format
link "$DOTFILES_DIR/nvim/.clang-format" "$HOME_DIR/.clang-format"

# ============================================================
# Arch Linux のみ
# ============================================================
if [ "$IS_WSL" = false ]; then

    # wofi
    link "$DOTFILES_DIR/wofi/config" "$HOME_DIR/.config/wofi/config"
    link "$DOTFILES_DIR/wofi/style.css" "$HOME_DIR/.config/wofi/style.css"

    # SKK
    link "$DOTFILES_DIR/skk/metadata.json" \
        "$HOME_DIR/.config/libskk/rules/myrule/metadata.json"
    link "$DOTFILES_DIR/skk/keymap/hiragana.json" \
        "$HOME_DIR/.config/libskk/rules/myrule/keymap/hiragana.json"
    link "$DOTFILES_DIR/skk/keymap/katakana.json" \
        "$HOME_DIR/.config/libskk/rules/myrule/keymap/katakana.json"

    # SDDM (要 sudo)
    sudo mkdir -p "/etc/sddm.conf.d"
    sudo ln -snf "$DOTFILES_DIR/sddm/theme.conf" "/etc/sddm.conf.d/theme.conf"
    if [ -d "/usr/share/sddm/themes/Sugar-Candy" ]; then
        sudo ln -snf "$DOTFILES_DIR/sddm/Sugar-Candy/theme.conf" \
            "/usr/share/sddm/themes/Sugar-Candy/theme.conf"
        sudo ln -snf "$DOTFILES_DIR/assets/lock/angel.png" \
            "/usr/share/sddm/themes/Sugar-Candy/Backgrounds/angel.png"
    fi

    # Hyprland
    link_dir "$DOTFILES_DIR/hypr" "$HOME_DIR/.config/hypr" "*.conf"
    link_dir "$DOTFILES_DIR/hypr/scripts" "$HOME_DIR/.config/hypr/scripts"

    # eww
    link "$DOTFILES_DIR/eww/eww.scss" "$HOME_DIR/.config/eww/eww.scss"
    link "$DOTFILES_DIR/eww/eww.yuck" "$HOME_DIR/.config/eww/eww.yuck"
    link_dir "$DOTFILES_DIR/eww/scripts" "$HOME_DIR/.config/eww/scripts"
    link "$DOTFILES_DIR/eww/eww-keycast" "$HOME_DIR/.config/eww/eww-keycast"

    # quickshell
    QS_SRC="$DOTFILES_DIR/quickshell/qs-hyprview"
    QS_DST="$HOME_DIR/.config/quickshell/qs-hyprview"
    for subdir in "" modules layouts; do
        link_dir "$QS_SRC/$subdir" "$QS_DST/$subdir" "*.qml"
    done

    # NetworkManager (要 sudo)
    sudo mkdir -p "/etc/NetworkManager/"
    sudo ln -snf "$DOTFILES_DIR/etc/NetworkManager/NetworkManager.conf" \
        "/etc/NetworkManager/NetworkManager.conf"

    # fcitx5
    link_dir "$DOTFILES_DIR/fcitx5/conf" "$HOME_DIR/.config/fcitx5/conf" "*.conf"
    link "$DOTFILES_DIR/fcitx5/config" "$HOME_DIR/.config/fcitx5/config"
    link "$DOTFILES_DIR/fcitx5/profile" "$HOME_DIR/.config/fcitx5/profile"

fi

echo "deploy complete."
