# dotfiles　

###### 🇯🇵 日本語 | 🇺🇸 [English](./README.en.md)

### 最高の生活空間

#### ― btw, I use Arch (and Hyprland, and Neovim, and...)

![OS](https://img.shields.io/badge/OS-Arch%20Linux%20%2B%20WSL-7F77DD?style=flat-square&logoColor=white)
![WM](https://img.shields.io/badge/WM-Hyprland-1D9E75?style=flat-square)
![Editor](https://img.shields.io/badge/Editor-Neovim-639922?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-Zsh-BA7517?style=flat-square)
![Terminal](https://img.shields.io/badge/Terminal-WezTerm-D4537E?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-888780?style=flat-square)

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

<details>
<summary>WSL (Ubuntu)</summary>

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
# PowerShell
wsl --terminate Ubuntu
wsl -d Ubuntu
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

</details>

<details>
<summary>Arch Linux</summary>

#### 0. 事前準備

- [Arch Linux](https://wiki.archlinux.org/title/Installation_guide)のインストール
- yay (AURヘルパー) のインストール

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

#### 1. 以降

WSLの手順 1. 最低限の準備 ~ 8. パスの反映 と同様に。

> ただし、6. WSLを再起動はスキップ

</details>

## 💘 こだわりポイント

## 📄 ライセンス

MIT License © 2025 Samemaru07

詳細は [LICENSE](./LICENSE) を参照してください。

Arch Linux の設定は [Monasm](https://github.com/Mon4sm/monasm-dots) さんの dotfiles をベースに改良しました。ありがとうございます 🙏

---

### 🖼️ 画像の出典

画像の著作権は各権利者に帰属します。再配布・二次利用は禁止します。

| ファイル                         | 出典                                                                                                        |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `eww/mito.png`                   | 「青春ブタ野郎は大垣に灯る夢を見ない」 イベントでの自撮り                                                   |
| `eww/seri_orihime.jpg`           | 蒼穹のファフナー EXODUS 第8話「平和を夢見て」                                                               |
| `eww-keycast/mimic.JPG`          | 葬送のフリーレン 第1期 第23話「迷宮攻略」                                                                   |
| `home/aobuta.png`                | 「青春ブタ野郎は大垣に灯る夢を見ない」イベントでの自撮り                                                    |
| `home/fafner.jpeg`               | 「蒼穹のファフナー 20周年記念 尾道コラボ」イベントでの自撮り                                                |
| `lock/angel.png`                 | [壁紙配布サイト](https://kabekin.com/wallpaper/anime/building_tenshinoakuma_2023_0602/gZGG/1440/1080)       |
| `lock/ironblood.png`             | [Reddit](https://www.reddit.com/r/Gundam/comments/1c14vxp/official_mobile_suit_gundam_ironblooded_orphans/) |
| `lock/witch.png`                 | [機動戦士ガンダム 水星の魔女 公式](https://gundam-official.com/witch-from-mercury/gallery/visual/)          |
| `quickshell/misato.jpg`          | ヱヴァンゲリヲン新劇場版：破                                                                                |
| `terminal/dairoku.jpg`           | [壁紙配布サイト](https://anihonetwallpaper.com/tag/%E5%A6%99%E9%AB%98%E8%89%A6%E3%81%93%E3%82%8C)           |
| `terminal/fastfetch/asuka.jpg`   | ヱヴァンゲリヲン新劇場版：破                                                                                |
| `terminal/fastfetch/frieren.JPG` | 葬送のフリーレン 第1期 第23話「迷宮攻略」                                                                   |
| `terminal/hala.png`              | [機動戦士ガンダム 閃光のハサウェイ 公開記念PV](https://www.youtube.com/watch?v=Mlb4WaADW2s)                 |
| `terminal/seri.jpg`              | 蒼穹のファフナー EXODUS 第16話「命の行方」                                                                  |
| `widget/maya.PNG`                | 蒼穹のファフナー THE BEYOND 第12話「蒼穹の彼方」                                                            |
| `widget/suremio.JPG`             | 機動戦士ガンダム 水星の魔女 第1クール OP                                                                    |
| `wofi/sakura.jpg`                | [@susuki_Mk2](https://x.com/susuki_Mk2/status/1373651612766502917)                                          |
