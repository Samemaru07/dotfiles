#!/bin/bash
DOTFILES_DIR="$HOME/dotfiles"
ln -snf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -snf "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -snf "$DOTFILES_DIR/shell/.profile" "$HOME/.profile"
ln -snf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config"
ln -snf "$DOTFILES_DIR/wezterm/.config/wezterm" "$HOME/.config/wezterm"
ln -snf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
