#!/bin/bash

set -e

# ============================================================
# 作業ディレクトリ
# ============================================================
WORK_DIR="$HOME/Downloads"
mkdir -p "$WORK_DIR"

# ============================================================
# パッケージマネージャの判定
# ============================================================
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
else
    echo "Error: Neither apt (Ubuntu/Debian) nor pacman (Arch Linux) found."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"

# WSL判定
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
else
    IS_WSL=false
fi

# ============================================================
# Neovim 本体（公式バイナリ）
# ============================================================
install_neovim() {
    echo "Installing Neovim (official binary)..."
    local archive="nvim-linux-x86_64.tar.gz"
    curl -LO --output-dir "$WORK_DIR" "https://github.com/neovim/neovim/releases/latest/download/$archive"
    sudo tar -C /opt -xzf "$WORK_DIR/$archive"
    rm -f "$WORK_DIR/$archive"

    # PATHへの追記（未登録の場合のみ）
    if ! grep -q '/opt/nvim-linux-x86_64/bin' "$HOME/.zshrc" 2>/dev/null; then
        echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> "$HOME/.zshrc"
    fi
    echo "Neovim installed."
}

# ============================================================
# fastfetch（公式バイナリ）
# ============================================================
install_fastfetch() {
    echo "Installing fastfetch (official binary)..."
    local archive="fastfetch-linux-amd64.tar.gz"
    curl -LO --output-dir "$WORK_DIR" "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/$archive"
    tar -xzf "$WORK_DIR/$archive" -C "$WORK_DIR"
    mkdir -p "$HOME/.local/bin"
    cp "$WORK_DIR/fastfetch-linux-amd64/usr/bin/fastfetch" "$HOME/.local/bin/fastfetch"
    chmod +x "$HOME/.local/bin/fastfetch"
    rm -rf "$WORK_DIR/fastfetch-linux-amd64" "$WORK_DIR/$archive"
    echo "fastfetch installed."
}

# ============================================================
# apt 用インストール
# ============================================================
install_apt() {
    echo "Updating apt repositories..."
    sudo apt-get update

    echo "Installing core tools..."
    sudo apt-get install -y git curl wget unzip tar gzip build-essential zsh

    # WSL固有
    if [ "$IS_WSL" = true ]; then
        echo "Installing WSL-specific packages..."
        sudo apt-get install -y pulseaudio-utils sound-theme-freedesktop xclip
    else
        sudo apt-get install -y xclip wl-clipboard
    fi

    echo "Installing search tools..."
    sudo apt-get install -y ripgrep fd-find
    # Ubuntu では fd-find として入るため fd にシンリンクを貼る
    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi

    echo "Installing language runtimes..."
    # Rust: apt版は古いため rustup で入れる（後述）。ここでは入れない。
    # Go:   apt版は古いため公式tarballで入れる（後述）。ここでは入れない。
    sudo apt-get install -y python3 python3-pip python3-venv
    # Node.js: NodeSource 経由で LTS を入れる（後述）。
    sudo apt-get install -y perl
    sudo apt-get install -y php php-xml composer

    echo "Installing formatter/linter tools..."
    sudo apt-get install -y shellcheck shfmt
    sudo apt-get install -y clang-format chktex
    sudo apt-get install -y pgformatter || echo "Warning: pgformatter not found in apt repos"
    sudo apt-get install -y ghdl        || echo "Warning: ghdl not found in apt repos"

    # LaTeX (任意)
    read -rp "Do you want to install LaTeX (TexLive)? This is large. (y/N) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get install -y texlive-full latexmk
    fi
}

# ============================================================
# pacman 用インストール
# ============================================================
install_pacman() {
    echo "Updating pacman repositories..."
    sudo pacman -Syu --noconfirm

    echo "Installing dependencies..."
    sudo pacman -S --noconfirm --needed \
        git curl wget unzip tar gzip base-devel zsh \
        ripgrep fd \
        xclip wl-clipboard \
        python python-pip \
        nodejs npm \
        go rustup perl php composer \
        shellcheck shfmt ghdl clang pgformatter chktex

    # LaTeX (任意)
    read -rp "Do you want to install LaTeX (TexLive)? This is large. (y/N) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -S --noconfirm --needed \
            texlive-basic texlive-latex texlive-latexrecommended \
            texlive-latexextra texlive-fontsrecommended texlive-fontsextra latexmk
    fi
}

# ============================================================
# Rust (rustup)
# ※ apt版 cargo/rustc とは競合するため、rustup で一本化する
# ============================================================
install_rust() {
    if command -v rustup &> /dev/null; then
        echo "rustup already installed, skipping."
        return
    fi
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    # 現セッションで cargo を使えるようにする
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"

    # PATHへの追記（未登録の場合のみ）
    if ! grep -q '\.cargo/env' "$HOME/.zshrc" 2>/dev/null; then
        echo '. "$HOME/.cargo/env"' >> "$HOME/.zshrc"
    fi
    echo "Rust installed."
}

# ============================================================
# Go（公式tarball）
# ※ apt版は古いため公式から取得する
# ============================================================
install_go() {
    if command -v go &> /dev/null; then
        echo "Go already installed ($(go version)), skipping."
        return
    fi

    echo "Fetching latest Go version..."
    local GO_VERSION
    GO_VERSION=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1 | sed 's/^go//')
    local archive="go${GO_VERSION}.linux-amd64.tar.gz"

    echo "Installing Go ${GO_VERSION}..."
    curl -LO --output-dir "$WORK_DIR" "https://go.dev/dl/$archive"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$WORK_DIR/$archive"
    rm -f "$WORK_DIR/$archive"

    # PATHへの追記（未登録の場合のみ）
    if ! grep -q '/usr/local/go/bin' "$HOME/.zshrc" 2>/dev/null; then
        echo 'export PATH="$PATH:/usr/local/go/bin"' >> "$HOME/.zshrc"
    fi
    export PATH="$PATH:/usr/local/go/bin"
    echo "Go installed."
}

# ============================================================
# Node.js（NodeSource LTS）
# ※ apt版は古いため NodeSource 経由で入れる
# ============================================================
install_node() {
    if command -v node &> /dev/null; then
        echo "Node.js already installed ($(node --version)), skipping."
        return
    fi
    echo "Installing Node.js (LTS via NodeSource)..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js installed."
}

# ============================================================
# Deno
# ============================================================
install_deno() {
    if command -v deno &> /dev/null; then
        echo "Deno already installed, skipping."
        return
    fi
    echo "Installing Deno..."
    curl -fsSL https://deno.land/install.sh | sh
    # PATHへの追記（未登録の場合のみ）
    if ! grep -q '\.deno/bin' "$HOME/.zshrc" 2>/dev/null; then
        echo 'export PATH="$PATH:$HOME/.deno/bin"' >> "$HOME/.zshrc"
    fi
    echo "Deno installed."
}

# ============================================================
# 言語別ツール（nvim設定から要求されるもの）
# ============================================================
install_tool_deps() {
    echo "Installing language-specific tools for Neovim..."

    # Python
    echo "  Python: pynvim, ruff, black, debugpy, neovim-remote"
    pip3 install --user --upgrade pynvim ruff black debugpy neovim-remote \
        --break-system-packages 2>/dev/null \
        || pip3 install --user --upgrade pynvim ruff black debugpy neovim-remote

    # Node
    echo "  Node: neovim, tree-sitter-cli, prettier"
    sudo npm install -g neovim tree-sitter-cli prettier \
        || npm install -g neovim tree-sitter-cli prettier

    # Go
    echo "  Go: goimports, delve"
    if command -v go &> /dev/null; then
        export GOPATH="$HOME/go"
        export PATH="$PATH:$GOPATH/bin"
        go install golang.org/x/tools/cmd/goimports@latest
        go install github.com/go-delve/delve/cmd/dlv@latest
    else
        echo "  Go not found, skipping."
    fi

    # Rust
    echo "  Rust: stylua"
    if command -v cargo &> /dev/null; then
        cargo install stylua
    else
        echo "  cargo not found, skipping."
    fi

    # PHP
    echo "  PHP: pint"
    if command -v composer &> /dev/null; then
        composer global require laravel/pint
    else
        echo "  composer not found, skipping."
    fi
}

# ============================================================
# SKK辞書
# ============================================================
setup_skk() {
    local SKK_DIR="$HOME/.skk"
    if [ -d "$SKK_DIR" ]; then
        echo "SKK directory already exists, skipping."
        return
    fi

    echo "Downloading SKK dictionaries..."
    mkdir -p "$SKK_DIR"

    # SKK-JISYO.L
    curl -LO --output-dir "$SKK_DIR" \
        "https://skk-dev.github.io/dict/SKK-JISYO.L.gz"
    gunzip "$SKK_DIR/SKK-JISYO.L.gz"

    # 絵文字辞書
    curl -o "$SKK_DIR/SKK-JISYO.emoji.utf8" \
        "https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8" \
        || echo "Warning: Emoji dict download failed, skipping."
    if [ -f "$SKK_DIR/SKK-JISYO.emoji.utf8.gz" ]; then
        gunzip "$SKK_DIR/SKK-JISYO.emoji.utf8.gz"
    fi

    echo "SKK dictionaries installed."
}

# ============================================================
# 実行
# ============================================================
# 1. システムパッケージ
if [ "$PKG_MANAGER" = "apt" ]; then
    install_apt
    install_node   # apt版Nodeは古いため NodeSource で上書き
elif [ "$PKG_MANAGER" = "pacman" ]; then
    install_pacman
fi

# 2. 最新バイナリが必要なもの
install_neovim
install_fastfetch
install_rust
install_go
install_deno

# 3. 言語別nvimツール
install_tool_deps

# 4. SKK辞書
setup_skk

# ============================================================
# 完了メッセージ
# ============================================================
echo ""
echo "=========================================="
echo " Installation complete!"
echo "=========================================="
echo ""
echo "以下のPATHが .zshrc に追記されています:"
echo "  /opt/nvim-linux-x86_64/bin  (Neovim)"
echo "  /usr/local/go/bin           (Go)"
echo "  \$HOME/.cargo/env           (Rust/cargo)"
echo "  \$HOME/.deno/bin            (Deno)"
echo "  \$HOME/.local/bin           (fastfetch, Python tools)"
echo "  \$HOME/go/bin               (Go tools)"
echo "  \$HOME/.config/composer/vendor/bin  (PHP tools)"
echo ""
echo "変更を反映するには: source ~/.zshrc"
echo ""
echo "[手動対応が必要なもの]"
echo "  win32yank (WSL クリップボード):"
echo "  https://github.com/equalsraf/win32yank/releases から"
echo "  win32yank.exe を C:\\tools\\ に配置してください。"
