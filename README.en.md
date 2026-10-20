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
    - 👉 Plugin Manager: [Fisher](https://github.com/jorgebucaran/fisher)
    - 👉 Prompt Plugin: [TIDE](https://github.com/IlanCosman/tide)
- Resource Monitor: [btop](https://github.com/aristocratos/btop)
- Version Control: [Git](https://git-scm.com/)
    - 👉 Tools: [lazygit](https://github.com/jesseduffield/lazygit) / [GitHub CLI (gh)](https://cli.github.com/)

### Shared across Arch Linux environments

- Window Manager: [Hyprland](https://hypr.land/)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Launcher: [wofi](https://hg.sr.ht/~scoopta/wofi)
- Logout Menu: [wlogout](https://github.com/ArtsyMacaw/wlogout)
- Display Manager: [SDDM](https://github.com/sddm/sddm/)
- Japanese Input: [fcitx5](https://fcitx-im.org/wiki/Fcitx_5) + [fcitx5-skk](https://github.com/fcitx/fcitx5-skk)
- Network Management: [NetworkManager](https://networkmanager.dev/)
- Audio: [PipeWire](https://pipewire.org/)

- Notifications: [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
- Audio Visualizer: [cava](https://github.com/karlstav/cava)
- Cursor: [Fern Cursor (FernCursor)](https://www.opendesktop.org/p/2352161/)
- RGB Lighting Control (desktop): [OpenRGB](https://openrgb.org/plugins.html)
    - 👉 Effects Plugin: [OpenRGB Effects Plugin](https://openrgb.org/plugin_effects.html)

### Laptop-only

- Sound firmware: [sof-firmware](https://archlinux.org/packages/extra/any/sof-firmware/)

### Laptop-specific configuration

On the laptop (hostname: `arch-laptop`), `hyprland.conf`, `hyprpaper.conf`, and `hypridle.conf` are not deployed.
The laptop currently manages its configuration in Lua format, and detailed Hyprland and Hyprpaper settings are maintained on the laptop itself.

### WSL Only (to be removed)

- Clipboard: [win32yank](https://github.com/equalsraf/win32yank)

## 📁 Directory Structure

Structure of the repository managed by chezmoi (`~/.local/share/chezmoi`).

```text
dotfiles/
    ├ .chezmoidata                                # chezmoi data files
    ├ Pictures/Wallpapers                         # Wallpapers
    ├ assets/                                     # Image assets for README
    ├ dot_config/                                 # Configuration files under ~/.config/
    │  ├ OpenRGB/                                 # OpenRGB config
    │  ├ cava/                                    # Audio visualizer config
    │  │  ├ shaders/                              # cava shaders
    │  │  └ themes/                               # cava themes
    │  ├ gh/                                      # GitHub CLI config
    │  ├ hypr/                                    # Hyprland / hypridle / hyprpaper config (partially excluded on laptop)
    │  ├ kitty/                                   # Kitty terminal config
    │  ├ private_Hyper/                           # Hyper terminal config (OS-specific path branching template)
    │  ├ private_fcitx5/                          # Japanese input config (fcitx5 + SKK)
    │  ├ private_fish/                            # fish shell config
    │  ├ quickshell/                              # quickshell widget config
    │  ├ swaync/                                  # SwayNotificationCenter config
    │  ├ waybar/                                  # Waybar config
    │  │  └ scripts/                              # Waybar scripts
    │  ├ wlogout/                                 # Logout menu config
    │  └ wofi/                                    # wofi launcher config
    ├ private_dot_ssh/                            # SSH client config (.ssh/config)
    ├ dot_gitconfig                               # Git global config (.gitconfig)
    ├ dot_tmux.conf                               # tmux config (.tmux.conf)
    ├ run_after_update-hyper.sh.tmpl              # Automation script to copy Hyper config to Windows side
    ├ run_after_update-wallpapers.sh.tmpl         # Automation script to update wallpapers
    ├ run_once_after_gh-login.sh                  # GitHub CLI initial login automation script
    ├ run_once_after_install-fish-plugins.sh      # fish plugin installation script
    ├ run_once_after_install-nvim-config.sh       # Neovim config installation script
    ├ run_once_after_install-nvim-venv.sh         # Python virtual environment setup script for Neovim
    ├ run_once_after_install-skk-dict.sh          # SKK dictionary installation script
    ├ run_once_after_install-win32yank.sh.tmpl    # win32yank installation script
    ├ run_once_after_set-default-image-viewer.sh  # Image viewer setup script
    └ run_once_before_install-packages.sh.tmpl    # Pre-package-installation setup script
```

## 🚀 Installation

<details>
<summary>WSL (Arch Linux)</summary>

#### Prerequisites

On a system where WSL is already installed, update WSL to the latest version in PowerShell before installing.

```powershell
# Update WSL
wsl --update

# Check the version
wsl --version
```

#### Install Arch Linux on WSL

##### 1. Install the distribution

Run this in an elevated PowerShell.

```powershell
wsl --install -d archlinux
```

If this is your first time installing WSL, WSL itself may not be up to date.
After installation, exit the Arch shell that starts automatically, stop WSL in PowerShell, and update it.

```bash
exit
```

```powershell
# Stop WSL
wsl --shutdown

# Update WSL
wsl --update

# Check the version
wsl --version

# Restart Arch
wsl -d archlinux
```

Run steps 2–5 below in the root shell of the Arch instance you started.

##### 2. Update the system

```bash
pacman -Syu
```

##### 3. Install packages

```bash
pacman -S --needed git chezmoi sudo
```

##### 4. Create a regular user

```bash
useradd -m -G wheel -s /bin/bash samemaru
passwd samemaru
```

Allow the `wheel` group to use sudo.

```bash
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
```

##### 5. Set the default user

```bash
printf '[user]\ndefault=samemaru\n' >> /etc/wsl.conf
exit
```

##### 6. Restart WSL

Run this in PowerShell.

```powershell
wsl --terminate archlinux
wsl -d archlinux
```

##### 7. Apply dotfiles

Run the following in WSL after logging in as `samemaru`.

```bash
chezmoi init --apply Samemaru07
```

> 📌 **Note**: Required packages, including the Neovim runtime and TeX Live, are installed at the beginning of the apply process.
> You will be prompted for your `sudo` password, and installation may take some time.
>
> A GitHub CLI (`gh`) login prompt will appear during the process.
> Select SSH as the protocol and continue through SSH key generation and registration with GitHub.
> This key is required to fetch the [Neovim](https://github.com/Samemaru07/nvim-config) configuration over SSH.
> Since a browser cannot be opened from WSL, open the displayed URL in a Windows browser and enter the code.
>
> The SKK dictionary for Neovim (`~/.skk/SKK-JISYO.L`), the Python virtual environment for Molten (`~/.local/share/nvim/venv`), and win32yank for clipboard integration are also installed automatically during this process.
>
> `~/.config/Hyper/hyper.json` is copied to `%APPDATA%\Hyper\hyper.json` on Windows.
> [Hyper Webview](https://github.com/Samemaru07/hyper-webview-fork) can be installed either before or after this copy.

##### 8. Change the shell

```bash
chsh -s $(which fish)
exit
```

Restart WSL in PowerShell to finish.

```powershell
wsl --terminate archlinux
wsl -d archlinux
```

</details>

<details>
<summary>Arch Linux</summary>

#### 0. Prerequisites

##### Install [Arch Linux](https://wiki.archlinux.org/title/Installation_guide)

##### Install [yay (AUR Helper)](https://github.com/Jguer/yay)

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
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

3. On the desktop, edit the config file via chezmoi and replace the theme name. On the laptop, edit the Lua-format configuration maintained on the laptop itself.

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

Install the basic tools required to run chezmoi.

```bash
sudo pacman -S --needed git chezmoi
```

#### 2. Apply dotfiles

```bash
chezmoi init --apply Samemaru07
```

> 📌 **Note**: Required packages are installed at the beginning of the apply process. AUR packages are installed through yay, which was installed during the prerequisites.
> You will be prompted for your `sudo` password, and installation may take some time.
>
> A GitHub CLI (`gh`) login prompt will appear during the process.
> Select SSH as the protocol and continue through SSH key generation and registration with GitHub.
> This key is required to fetch the [Neovim](https://github.com/Samemaru07/nvim-config) configuration over SSH.
>
> The SKK dictionary for Neovim and the Python virtual environment are also installed automatically during this process.

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
