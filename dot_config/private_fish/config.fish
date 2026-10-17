# ssh-agent
if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c) > /dev/null
    ssh-add "$HOME/.ssh/id_ed25519"
end

if status is-interactive
    # 起動の挨拶
    set -g fish_greeting

    # vi key bindings
    fish_vi_key_bindings

    # EDITORの設定
    set -gx EDITOR "nvim"

    # デスクトップ環境の設定
    set -gx DE generic
end

# Archのみ, ttyでのログイン成功後, Hyprlandを起動
if status is-login
    if test (tty) = "/dev/tty1"
        exec start-hyprland
    end
end

# Git/GitHubの通信プロトコル。学校ではHTTPSに
alias gith='git -c url."https://github.com/".insteadOf=git@github.com:'
