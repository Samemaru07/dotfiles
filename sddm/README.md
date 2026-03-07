# SDDM

Sugar-Candy テーマを使用。背景画像は `assets/lock/` へのシンボリックリンクで管理。

## セットアップ後に必要な作業

`/home/samemaru` のパーミッションが `700` のため、`sddm` ユーザーが背景画像を読めるよう ACL を設定する必要がある。

```bash
# パス通過権限
setfacl -m u:sddm:x /home/samemaru
setfacl -m u:sddm:x /home/samemaru/dotfiles
setfacl -m u:sddm:x /home/samemaru/dotfiles/assets
setfacl -m u:sddm:x /home/samemaru/dotfiles/assets/lock

# 背景画像の読み取り権限
setfacl -m u:sddm:r /home/samemaru/dotfiles/assets/lock/angel.png
setfacl -m u:sddm:r /home/samemaru/dotfiles/assets/lock/ironblood.png
setfacl -m u:sddm:r /home/samemaru/dotfiles/assets/lock/witch.png
```
