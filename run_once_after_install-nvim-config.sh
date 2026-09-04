#!/bin/bash

if [ ! -d "$HOME/.config/nvim" ]; then
    git clone "https://github.com/Samemaru07/nvim-config.git" "$HOME/.config/nvim"
fi
