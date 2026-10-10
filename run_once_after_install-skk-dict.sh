#!/bin/bash

# skkeleton用のSKK辞書を導入
if [ ! -f "$HOME/.skk/SKK-JISYO.L" ]; then
    mkdir -p "$HOME/.skk"
    curl -fsSLo "$HOME/.skk/SKK-JISYO.L" https://raw.githubusercontent.com/skk-dev/dict/master/SKK-JISYO.L
fi
