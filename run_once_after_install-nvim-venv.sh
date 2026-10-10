#!/bin/bash

# Neovim (Molten) 用のPython仮想環境とJupyterのruntimeディレクトリを作成
python -m venv "$HOME/.local/share/nvim/venv"
"$HOME/.local/share/nvim/venv/bin/pip" install pynvim jupyter_client ipykernel nbformat
mkdir -p "$HOME/.local/share/jupyter/runtime"
