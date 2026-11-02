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

# Neovim/Toggleterm/Tmux内でない場合のみfastfetchを実行
if not set -q TOGGLETERM_ID
    and test -z "$NVIM"
    and not set -q TMUX
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
# conda (遅延初期化: 初回のconda実行時にだけhookを読み込む)
if test -f /opt/miniforge/bin/conda
    function conda
        functions -e conda
        eval /opt/miniforge/bin/conda "shell.fish" "hook" | source
        conda $argv
    end
end
# <<< conda initialize <<<
