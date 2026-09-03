# dotfiles

###### 🇯🇵 [日本語](./README.md) | 🇺🇸 English

### The Ultimate Workspace

#### ― btw, I use Arch (and Hyprland, and Neovim, and...)

![OS](https://img.shields.io/badge/OS-Arch%20Linux%20%2B%20WSL-7F77DD?style=flat-square&logoColor=white)
![WM](https://img.shields.io/badge/WM-Hyprland-1D9E75?style=flat-square)
![Editor](https://img.shields.io/badge/Editor-Neovim-639922?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-fish-BA7517?style=flat-square)
![Terminal](https://img.shields.io/badge/Terminal-Hyper-D4537E?style=flat-square)
![Manager](https://img.shields.io/badge/Manager-chezmoi-00ADD8?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-888780?style=flat-square)

<!-- TODO: Video-->

<p align="center">
    <img src="./assets/ws1.png" alt="WS1" width="49%">
    <img src="./assets/ws2.png" alt="WS2" width="49%">
    <img src="./assets/ws3.png" alt="WS3" width="49%">
    <img src="./assets/ws4.png" alt="WS4" width="49%">
</p>

## 🛠️ Tools

### Arch + WSL (Common)

- Dotfiles Manager: [chezmoi](https://www.chezmoi.io/)
- Editor: [Neovim](https://neovim.io/)
    - 👉 Check out my ultimate Neovim config [here](https://github.com/Samemaru07/nvim-config.git)
- Terminal Emulator: [Hyper](https://hyper.is/)
    - 👉 Custom Hyper integrated with Webview, SKK, and background images: [Hyper-webview](https://github.com/Samemaru07/hyper-webview-fork)
- Shell: [fish](https://fishshell.com/)
- Resource Monitor: [btop](https://github.com/aristocratos/btop)
- Version Control: [Git](https://git-scm.com/)
    - 👉 Tools: [lazygit](https://github.com/jesseduffield/lazygit) / [GitHub CLI (gh)](https://cli.github.com/)

### Arch Linux Only

- Window Manager: [Hyprland](https://hypr.land/)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Launcher: [wofi](https://hg.sr.ht/~scoopta/wofi)
- Logout Menu: [wlogout](https://github.com/ArtsyMacaw/wlogout)
- Display Manager: [SDDM](https://github.com/sddm/sddm/)
- Japanese Input: [fcitx5](https://fcitx-im.org/wiki/Fcitx_5) + [fcitx5-skk](https://github.com/fcitx/fcitx5-skk)
- Network Management: [NetworkManager](https://networkmanager.dev/)
- Notifications: [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
- Audio Visualizer: [cava](https://github.com/karlstav/cava)
- Cursor: [Fern Cursor (FernCursor)](https://www.opendesktop.org/p/2352161/)

### WSL Only

- Clipboard: [win32yank](https://github.com/equalsraf/win32yank)

## 📁 Directory Structure

Structure of the repository managed by chezmoi (`~/.local/share/chezmoi`).

```text
dotfiles/
    ├ Pictures/Wallpapers/           # Wallpapers
    ├ assets/                        # Image assets for README
    ├ dot_config/                    # Configuration files under ~/.config/
    │ ├ cava/                        # Audio visualizer config
    │ ├ gh/                          # GitHub CLI config
    │ ├ hypr/                        # Hyprland / hypridle / hyprpaper config
    │ ├ kitty/                       # Kitty terminal config
    │ ├ private_Hyper/               # Hyper terminal config (OS-specific path branching template)
    │ ├ private_fcitx5/              # Japanese input config (fcitx5 + SKK)
    │ ├ private_fish/                # fish shell config
    │ ├ quickshell/                  # quickshell widget config
    │ ├ swaync/                      # SwayNotificationCenter config
    │ ├ systemd/user/                # systemd user service (for OpenRGB sleep wake)
    │ ├ waybar/                      # Waybar config
    │ ├ wlogout/                     # Logout menu config
    │ └ wofi/                        # wofi launcher config
    ├ private_dot_ssh/               # SSH client config (.ssh/config)
    ├ dot_gitconfig                  # Git global config (.gitconfig)
    ├ dot_tmux.conf                  # tmux config (.tmux.conf)
    ├ run_after_update-hyper.sh.tmpl # Automation script to copy Hyper config to Windows side
    └ run_once_after_gh-login.sh     # GitHub CLI initial login automation script
```

## 🚀 Installation

<details>
<summary>WSL (Ubuntu)</summary>

#### 0. Prerequisites (Windows)

##### Install Ubuntu

```bash
# PowerShell
wsl --install -d Ubuntu
```

#### 1. Install Required Packages

Install tools required to run chezmoi and the clipboard integration tool ([win32yank](https://github.com/equalsraf/win32yank)).

```bash
sudo apt update
sudo apt install -y git curl fish gh unzip

# Install win32yank
mkdir -p ~/.local/bin
curl -sLo /tmp/win32yank.zip [https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip](https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip)
unzip -p /tmp/win32yank.zip win32yank.exe > ~/.local/bin/win32yank.exe
chmod +x ~/.local/bin/win32yank.exe
rm /tmp/win32yank.zip
```

#### 2. Apply dotfiles

Simply run the following one-liner to automatically clone the repository, place the files, and set up sync scripts to the Windows side.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Samemaru07
```

> 📌 **Note**: A GitHub CLI (`gh`) login prompt will appear during the process. Follow the on-screen instructions to complete browser authentication. (You can also generate and register an SSH key during this process.)

#### 3. Change Default Shell

```bash
chsh -s $(which fish)
```

#### 4. Restart WSL

Restart WSL to fully apply the settings and the default shell.

```bash
# WSL
exit
# PowerShell
wsl --terminate Ubuntu
wsl -d Ubuntu
```

</details>

<details>
<summary>Arch Linux</summary>

#### 0. Prerequisites

##### Install [Arch Linux](https://wiki.archlinux.org/title/Installation_guide)

##### Install [yay (AUR Helper)](https://github.com/Jguer/yay)

```bash
sudo pacman -S --needed git base-devel
git clone [https://aur.archlinux.org/yay.git](https://aur.archlinux.org/yay.git)
cd yay && makepkg -si
```

##### Install Cursor Theme (Default: FernCursor)

- Download [FernCursor](https://www.opendesktop.org/p/2352161/) to `~/Downloads`.
- Extract directly to `~/.icons` with the following command:

```bash
mkdir -p ~/.icons
unzip -q ~/Downloads/FernCursor.zip -d ~/.icons
```

<details>

<summary><strong>If you want to use another theme</strong></summary>

1. Download your preferred theme to `~/Downloads` from [this site](https://www.opendesktop.org/browse?cat=107&ord=latest).
2. Run the following command to place the theme:

```bash
mkdir -p ~/.icons
unzip -q ~/Downloads/<theme_name>.zip -d ~/.icons
```

3. Edit the config file via chezmoi and replace the theme name.

- Edit `hyprland.conf`:

```bash
chezmoi edit ~/.config/hypr/hyprland.conf
```

```diff
- env = XCURSOR_THEME,FernCursor
+ env = XCURSOR_THEME,<theme_name>
```

</details>

#### 1. Install Required Packages

Install basic tools required to run chezmoi and apply settings.

```bash
sudo pacman -S --needed curl git fish github-cli
```

#### 2. Apply dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Samemaru07
```

> 📌 **Note**: A GitHub CLI (`gh`) login prompt will appear during the process. Follow the on-screen instructions to complete browser authentication. (You can also generate and register an SSH key during this process.)

#### 3. Change Default Shell

```bash
chsh -s $(which fish)
```

</details>

## 💘 Key Features

- Seamless dotfiles management and synchronization between Arch Linux and WSL environments using chezmoi.

## 📄 License

MIT License © 2026 Samemaru07

See [LICENSE](./LICENSE) for details.

The Arch Linux configurations are based on and improved from [ViegPhunt](https://github.com/ViegPhunt/Arch-Hyprland)'s dotfiles.
Thank you 🙏

---

### 🖼️ Image Sources

The copyrights of the images belong to their respective owners. Redistribution and secondary use are prohibited.

| File                                                  | Source                                                                                              |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `Pictures/Wallpapers/fafner.png`                      | Selfie at the "Fafner in the Azure 20th Anniversary Onomichi Collaboration" event                   |
| `Pictures/Wallpapers/hala.png`                        | [Mobile Suit Gundam Hathaway Release Commemoration PV](https://www.youtube.com/watch?v=Mlb4WaADW2s) |
| `dot_config/quickshell/qs-hyprview/assets/misato.jpg` | Evangelion: 2.0 You Can (Not) Advance                                                               |
| `dot_config/wofi/sakura.jpg`                          | [@susuki_Mk2](https://x.com/susuki_Mk2/status/1373651612766502917)                                  |
