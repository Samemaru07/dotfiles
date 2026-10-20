# ssh-agent
if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c) > /dev/null
    ssh-add "$HOME/.ssh/id_ed25519"
end

# alias
# Git/GitHubの通信プロトコル。学校ではHTTPSに
alias gith='git -c url."https://github.com/".insteadOf=git@github.com:'

# fastfetch
function ff
    clear
    if set -q TMUX
        fastfetch --raw ~/.config/fastfetch/asuka_tmux.raw --logo-width 50 --logo-height 20
    else
        fastfetch
    end
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

    # Neovim/Toggleterm 内でない場合のみ fastfetch を実行
    if not set -q TOGGLETERM_ID
        and test -z "$NVIM"
        and not set -q __FF_DONE
        set -g __FF_DONE 1
        if not set -q TMUX
            fastfetch
        end
    end
end

# Archのみ, ttyでのログイン成功後, Hyprlandを起動
if status is-login
    if test (tty) = "/dev/tty1"
        exec start-hyprland
    end
end
