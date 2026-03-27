# dotfiles

🇯🇵 日本語 / 🇺🇸 English

<!--TODO: スクショ-->

## 🛠️使用ツール

### Arch + WSL

- エディタ: [Neovim](https://neovim.io/)
    - 👉 Neovimの最強configは[コチラ](https://github.com/Samemaru07/Neovim-setup.git)
- ターミナルエミュレータ: [WezTerm](https://wezterm.org/index.html)
- シェル: [Zsh](https://www.zsh.org/)
- ターミナルマルチプレクサ: [tmux](https://github.com/tmux/tmux/wiki)
- システム情報表示: [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- バージョン管理: [Git](https://git-scm.com/)
    - 👉 ツール: [lazygit](https://github.com/jesseduffield/lazygit)

### Arch Linux専用

- ウィンドウマネージャ: [Hyprland](https://hypr.land/)
- ウィジェット・バー: [eww](https://github.com/elkowar/eww) / [quickshell](https://quickshell.org/)
- ランチャー: [wofi](https://hg.sr.ht/~scoopta/wofi)
- ディスプレイマネージャ: [SDDM](https://github.com/sddm/sddm/)
- 日本語入力: [fcitx5](https://fcitx-im.org/wiki/Fcitx_5) + [fcitx5-skk](https://github.com/fcitx/fcitx5-skk)
- ネットワーク管理: [NetworkManager](https://networkmanager.dev/)
- keycaster: [[自作] eww-keycast](https://github.com/Samemaru07/eww-keycast.git)

### WSL専用

- クリップボード: [win32yank](https://github.com/equalsraf/win32yank)

## 📁 ディレクトリ構成

```
dotfiles/
    ├ applications/ # WezTermのデスクトップエントリ
    ├ assets/ # 壁紙・アイコンなどの画像素材 (Arch・WSL共通)
    ├ etc/ # NetworkManager設定
    ├ eww/ # ewwウィジェット設定
    │   └ eww-keycast/ # キー入力表示ウィジェット (git submodule)
    ├ fastfetch/ # システム情報表示設定
    ├ fcitx5/ # 日本語入力設定 (fcitx5 + SKK)
    ├ git/ # Gitグローバル設定 (.gitconfig)
    ├ hypr/ # Hyprland / hypridle/ hyprlock / hyprpaper設定
    ├ keymap/ # キーマップ画像
    ├ libskk/ # SKKカスタムキーマップルール
    ├ nvim/ # Neovim設定 (git submodule)
    ├ openrgb/ # OpenRGB (PCファンのRGBライティング) 設定
    ├ p10k/ # Powerlevel10k設定
    ├ quickshell/ # quickshellウィジェット設定
    ├ scripts/ # 汎用スクリプト
    ├ sddm/ # SDDMテーマ設定
    ├ shell/ # シェル共通設定 (.profile)
    ├ skk/ # SKKキーマップ設定
    ├ tmux/ # tmux設定
    ├ wezterm/ # WezTerm設定
    ├ wofi/ # wofiランチャー設定
    ├ zsh/ # Zsh設定 (.zshrc)
    ├ deploy.sh # シンボリックリンク展開スクリプト
    └ bootstrap.sh # 初回セットアップスクリプト
```

## 🚀 インストール

### WSL (Ubuntu)

#### 0. 事前準備 (Windows)

##### Ubuntuのインストール

```bash
# PowerShell
wsl --install -d Ubuntu
```

##### win32yank.exeの配置

1. [win32yank.exe](https://github.com/equalsraf/win32yank/releases)を取得。
2. `C:\tools\`に解凍・展開

#### 1. 最低限の準備

```bash
sudo apt update
sudo apt install curl git -y
```

#### 2. dotfilesのclone

```bash
git clone --recurse-submodules https://github.com/Samemaru07/dotfiles.git
```

- 別ブランチを使いたい場合:
    ```bash
    git clone -b <branch> --recurse-submodules https://github.com/Samemaru07/dotfiles.git
    ```

#### 3. ツール・パッケージのインストール

```bash
cd ~/dotfiles
bash bootstrap.sh
```

#### 4. シェルの変更 (bash→Zsh)

```bash
chsh -s $(which zsh)
```

#### 5. 公開鍵認証 (GitHub) の設定

```bash
ssh-keygen -t ed25519 -C "<your@mail>"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

- 出力された公開鍵を、[GitHub](https://github.com/settings/keys)に登録。
- 確認
    ```bash
    ssh -T git@github.com
    ```

#### 6. WSLを再起動

```bash
# WSL
exit
# Powerhsell
wsl
```

#### 7. シンボリックリンクの展開

```bash
cd ~/dotfiles
bash deploy.sh
```

#### 8. パスの反映

```bash
source ~/.zshrc
```

### Arch Linux

#### 0. 事前準備

- [Arch Linux](https://wiki.archlinux.org/title/Installation_guide)のインストール
- yay (AURヘルパー) のインストール

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

#### 1. 以降

WSLの手順[1. 最低限の準備](#1.-最低限の準備) ~ [8. パスの反映](#8.-パスの反映)と同様に。

> ただし、[6. WSLを再起動](#6.-wslを再起動)はスキップ

## 💘 こだわりポイント

## ライセンス
