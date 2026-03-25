# dotfiles

🇯🇵 日本語 / 🇺🇸 English

<!--TODO: スクショ-->

## 使用ツール

## 🛠️使用ツール

## 📁 ディレクトリ構成

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
