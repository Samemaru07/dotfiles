# 非対話シェルのときはexit
if not status is-interactive
    exit
end

# ssh-agentについて、systemdのユーザユニットで動く方を使う
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

# alias
# fastfetch
function ff
    clear
    fastfetch
end

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
    fastfetch
end

# Archのみ, ttyでのログイン成功後, Hyprlandを起動
if status is-login
    if test (tty) = "/dev/tty1"
        exec start-hyprland
    end
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/miniforge/bin/conda
    eval /opt/miniforge/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/miniforge/etc/fish/conf.d/conda.fish"
        . "/opt/miniforge/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/miniforge/bin" $PATH
    end
end
# <<< conda initialize <<<
