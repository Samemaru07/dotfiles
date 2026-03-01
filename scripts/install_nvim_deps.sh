#!/bin/bash

set -e

# Detect Package Manager
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
else
    echo "Error: Neither apt (Ubuntu/Debian) nor pacman (Arch Linux) found."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"

install_apt() {
    echo "Updating apt repositories..."
    sudo apt-get update

    echo "Installing dependencies..."
    # Core tools
    sudo apt-get install -y git curl wget unzip tar gzip build-essential

    # Neovim (assuming user might need ppa for latest, but standard repo is often old)
    # We will just ensure dependencies here, not nvim itself unless requested, 
    # but the user asked to "clone and use", so they likely have nvim or will install it.
    # Let's install tools needed for the config.

    # Search tools
    sudo apt-get install -y ripgrep fd-find
    # Symlink fdfind to fd if not exists (common issue on Ubuntu)
    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
        sudo ln -s $(which fdfind) /usr/local/bin/fd
    fi

    # Clipboard
    if grep -q Microsoft /proc/version; then
        echo "WSL detected: utilizing wsl-clipboard via clip.exe usually, but installing xclip just in case."
        sudo apt-get install -y xclip
    else
        sudo apt-get install -y xclip wl-clipboard
    fi

    # Languages & Runtimes
    sudo apt-get install -y python3 python3-pip python3-venv
    sudo apt-get install -y nodejs npm perl
    sudo apt-get install -y cargo  # Rust for some tools

    # External Tools used in config
    sudo apt-get install -y shellcheck
    # ghdl for VHDL (might not be in default repos for all ubuntu versions, but often is)
    sudo apt-get install -y ghdl || echo "Warning: ghdl not found in apt repos"
    
    # Latex (Optional - huge download)
    read -p "Do you want to install LaTeX (TexLive)? This is large. (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get install -y texlive-full latexmk
    fi
}

install_pacman() {
    echo "Updating pacman repositories..."
    sudo pacman -Syu --noconfirm

    echo "Installing dependencies..."
    # Core tools & base-devel
    sudo pacman -S --noconfirm --needed git curl wget unzip tar gzip base-devel

    # Search tools
    sudo pacman -S --noconfirm --needed ripgrep fd

    # Clipboard
    sudo pacman -S --noconfirm --needed xclip wl-clipboard

    # Languages & Runtimes
    sudo pacman -S --noconfirm --needed python python-pip npm go rust perl
    
    # External Tools
    sudo pacman -S --noconfirm --needed shellcheck shfmt ghdl

    # Latex (Optional)
    read -p "Do you want to install LaTeX (TexLive)? This is large. (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Arch usually has texlive group or meta packages
        # texlive-most is a common meta-package for most users (often in AUR or community)
        # But standard repos have groups: texlive-basic, texlive-latex, etc.
        sudo pacman -S --noconfirm --needed texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended texlive-fontsextra latexmk
    fi
}

# Download SKK Dictionaries if missing
setup_skk() {
    SKK_DIR="$HOME/.skk"
    if [ ! -d "$SKK_DIR" ]; then
        echo "Creating $SKK_DIR and downloading SKK dictionaries..."
        mkdir -p "$SKK_DIR"
        cd "$SKK_DIR"
        wget http://openlab.ring.gr.jp/skk/skk/dic/SKK-JISYO.L.gz
        gunzip SKK-JISYO.L.gz
        # Emoji dict if available, or skip
        wget http://openlab.ring.gr.jp/skk/skk/dic/SKK-JISYO.emoji.gz || echo "Emoji dict download failed, skipping."
        if [ -f SKK-JISYO.emoji.gz ]; then gunzip SKK-JISYO.emoji.gz; mv SKK-JISYO.emoji SKK-JISYO.emoji-ja.utf8; fi
    else
        echo "SKK directory exists, skipping download."
    fi
}

if [ "$PKG_MANAGER" == "apt" ]; then
    install_apt
elif [ "$PKG_MANAGER" == "pacman" ]; then
    install_pacman
fi

setup_skk

echo "Dependency installation complete!"
echo "Note: Neovim itself was not installed/updated by this script. Ensure you have Neovim >= 0.9.0."
echo "If on Ubuntu, you might need: sudo add-apt-repository ppa:neovim-ppa/unstable && sudo apt update && sudo apt install neovim"
