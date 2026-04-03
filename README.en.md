# dotfiles

###### 🇯🇵 [日本語](./README.md) | 🇺🇸 English

### The perfect living space.

#### ─ btw, I use Arch (and Hyprland, and Neovim, and ...)

![OS](https://img.shields.io/badge/OS-Arch%20Linux%20%2B%20WSL-6F66DD?style=flat-square&logoColor=white)
![WM](https://img.shields.io/badge/WM-Hyprland-1D9E75?style=flat-square)
![Editor](https://img.shields.io/badge/Editor-Neovim-639922?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-Zsh-BA7517?style=flat-square)
![Terminal](https://img.shields.io/badge/Terminal-WezTerm-D4537E?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-888780?style=flat-square)

<!-- TODO: スクショ-->

## 🛠️ Tools

### Arch + WSL

- Editor: [Neovim](https://neovim.io/)
    - 👉 Check out the ultimate Neovim config [here](https://github.com/Samemaru07/Neovim-setup.git)
- Terminal Emulator: [WezTerm](https://wezterm.org/index.html)
- Shell: [Zsh](https://www.zsh.org/)
- Terminal Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
- System Info: [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- Version Control: [Git](https://git-scm.com)
    - 👉 Tool: [lazygit](https://github.com/jesseduffield/lazygit)

### Arch Linux only

- Window Manager: [Hyprland](https://hypr.land/)
- Widget & Bar: [eww](https://github.com/elkowar/eww) / [quickshell](https://quickshell.org/)
- Launcher: [wofi](https://hg.sr.ht/~scoopta/wofi)
- Display Manager: [SDDM](https://github.com/sddm/sddm/)
- Japanese Input: [fcitx5](https://fcitx-im.org/wiki/Fcitx_5) + [fcitx5-skk](https://github.com/fcitx/fcitx5-skk)
- Network Manager: [NetworkManager](https://networkmanager.dev/)
- Keycaster: [[custom] eww-keycast](https://github.com/Samemaru07/eww-keycast.git)

### WSL only

- Clipboard: [win32yank](https://github.com/equalsraf/win32yank)

## 📁 Directory Structure

```
dotfiles/
    ├ applications/ # WezTerm desktop entry
    ├ assets/ # Wallpapers, icons, and other image assets (shared across Arch & WSL)
    ├ etc/ # NetworkManager config
    ├ eww/ # eww widget config
    │   └ eww-keycast/ # Key input display widget (git submodule)
    ├ fastfetch/ # System info display config
    ├ fcitx5/ # Japanese input config (fcitx5 + SKK)
    ├ git/ # Git global config (.gitconfig)
    ├ hypr/ # Hyprland / hypridle / hyprlock / hyprpaper config
    ├ keymap/ # Keymap images
    ├ libskk/ # SKK custom keymap rules
    ├ nvim/ # Neovim config (git submodule)
    ├ openrgb/ # OpenRGB (PC fan RGB lighting) config
    ├ p10k/ # Powerlevel10k config
    ├ quickshell/ # quickshell widget config
    ├ scripts/ # General-purpose scripts
    ├ sddm/ # SDDM theme config
    ├ shell/ # Shell common config (.profile)
    ├ skk/ # SKK keymap config
    ├ tmux/ # tmux config
    ├ wezterm/ # WezTerm config
    ├ wofi/ # wofi launcher config
    ├ zsh/ # Zsh config (.zshrc)
    ├ deploy.sh # Symlink deployment script
    └ bootstrap.sh # Initial setup script
```

## 🚀 Installation

<details>
<summary>WSL (Ubuntu)</summary>

### WSL (Ubuntu)

#### 0. Prerequisites (Windows)

##### Install Ubuntu

```bash
# PowerShell
wsl --install -d Ubuntu
```

##### Place win32yank.exe

1. Download [win32yank.exe](https://github.com/equalsraf/win32yank/releases).
2. Extract it to `C:\tools\`

#### 1. Minimal setup

```bash
sudo apt update
sudo apt install curl git -y
```

#### 2. Clone dotfiles

```bash
git clone --recurse-submodules https://github.com/Samemaru07/dotfiles.git
```

- If you want to use a specific branch:

```bash
    git clone -b <branch> --recurse-submodules https://github.com/Samemaru07/dotfiles.git
```

#### 3. Install tools & packages

```bash
cd ~/dotfiles
bash bootstrap.sh
```

#### 4. Change shell (bash→Zsh)

```bash
chsh -s $(which zsh)
```

#### 5. Set up public key authentication (GitHub)

```bash
ssh-keygen -t ed25519 -C "<your@mail>"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

- Register the output public key on [GitHub](https://github.com/settings/keys).
- Verify:

```bash
    ssh -T git@github.com
```

#### 6. Restart WSL

```bash
# WSL
exit
# PowerShell
wsl --terminate Ubuntu
wsl -d Ubuntu
```

#### 7. Deploy symlinks

```bash
cd ~/dotfiles
bash deploy.sh
```

#### 8. Reload PATH

```bash
source ~/.zshrc
```

</details>

<details>
<summary>Arch Linux</summary>

### Arch Linux

#### 0. Prerequisites

- Install [Arch Linux](https://wiki.archlinux.org/title/Installation_guide)
- Install yay (AUR helper)

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

#### 1. Onwards

Follow the same steps as WSL: [1. Minimal setup](#1.-minimal-setup) ~ [8. Reload PATH](#8.-reload-path).

> Skip [6. Restart WSL](#6.-restart-wsl)

</details>

## 💘 Highlights

## 📄 License

MIT License © 2025 Samemaru07

See [LICENSE](./LICENSE) for details.

The Arch Linux configuration is based on and improved from [Monasm](https://github.com/Mon4sm/monasm-dots)'s dotfiles. Thank you 🙏

---

### 🖼️ Image Credits

All image copyrights belong to their respective owners. Redistribution and secondary use are prohibited.

| File                             | Source                                                                                                                |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `eww/mito.png`                   | Photo taken at the "Seishun Buta Yarou wa Ogaki ni Tomoru Yume wo Minai" event                                        |
| `eww/seri_orihime.jpg`           | Fafner in the Azure: EXODUS Episode 8「平和を夢見て」(Heiwa wo Yume Mite)                                             |
| `eww-keycast/mimic.JPG`          | Frieren: Beyond Journey's End Season 1 Episode 23「迷宮攻略」(Meikyuu Kouryaku)                                       |
| `home/aobuta.png`                | Photo taken at the "Seishun Buta Yarou wa Ogaki ni Tomoru Yume wo Minai" event                                        |
| `home/fafner.jpeg`               | Photo taken at the "Fafner in the Azure 20th Anniversary Onomichi Collaboration" event                                |
| `lock/angel.png`                 | [Wallpaper site](https://kabekin.com/wallpaper/anime/building_tenshinoakuma_2023_0602/gZGG/1440/1080)                 |
| `lock/ironblood.png`             | [Reddit](https://www.reddit.com/r/Gundam/comments/1c14vxp/official_mobile_suit_gundam_ironblooded_orphans/)           |
| `lock/witch.png`                 | [Mobile Suit Gundam: The Witch from Mercury Official](https://gundam-official.com/witch-from-mercury/gallery/visual/) |
| `quickshell/misato.jpg`          | Evangelion: 2.0 You Can (Not) Advance                                                                                 |
| `terminal/dairoku.jpg`           | [Wallpaper site](https://anihonetwallpaper.com/tag/%E5%A6%99%E9%AB%98%E8%89%A6%E3%81%93%E3%82%8C)                     |
| `terminal/fastfetch/asuka.jpg`   | Evangelion: 2.0 You Can (Not) Advance                                                                                 |
| `terminal/fastfetch/frieren.JPG` | Frieren: Beyond Journey's End Season 1 Episode 23「迷宮攻略」(Meikyuu Kouryaku)                                       |
| `terminal/hala.png`              | [Mobile Suit Gundam: Hathaway's Flash Release Commemoration PV](https://www.youtube.com/watch?v=Mlb4WaADW2s)          |
| `terminal/seri.jpg`              | Fafner in the Azure: EXODUS Episode 16「命の行方」(Inochi no Yukue)                                                   |
| `widget/maya.PNG`                | Fafner in the Azure: THE BEYOND Episode 12「蒼穹の彼方」(Soukyu no Kanata)                                            |
| `widget/suremio.JPG`             | Mobile Suit Gundam: The Witch from Mercury Season 1 OP                                                                |
| `wofi/sakura.jpg`                | [@susuki_Mk2](https://x.com/susuki_Mk2/status/1373651612766502917)                                                    |
