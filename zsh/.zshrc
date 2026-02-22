if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  fastfetch
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/usr/local/go/bin:$PATH"
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="/home/samemaru/go/bin:$PATH"

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
source ~/powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$PATH:/home/samemaru/.local/bin"

if command -v batcat &> /dev/null; then
  alias cat='batcat --style=plain'
elif command -v bat &> /dev/null; then
  alias cat='bat --style=plain'
fi

if command -v lsd &> /dev/null; then
  alias ls='lsd --icon=always'
  alias la='lsd --icon=always -a'
  alias ll='lsd --icon=always -l -g'
  alias lt='lsd --icon=always --tree'
fi

if command -v fdfind &> /dev/null; then
  alias fd='fdfind'
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# 重複していたPATH記述を整理
export PATH="/home/samemaru/.nvm/versions/node/v22.21.0/bin:/home/samemaru/go/bin:/snap/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:/home/samemaru/.local/share/zinit/polaris/bin:/home/samemaru/.cargo/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/home/samemaru/.local/bin:/usr/local/go/bin:$PATH"

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

bindkey '^E' backward-kill-word
bindkey '^R' kill-word

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
. "$DENO_INSTALL/env"
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin:$PATH"
. "/home/samemaru/.deno/env"

export PATH="$HOME/development/flutter/bin:$PATH"
export PATH=$PATH:/mnt/c/Users/nakayama/AppData/Local/Android/Sdk/platform-tools
alias adb="/mnt/c/Users/nakayama/AppData/Local/Android/Sdk/platform-tools/adb.exe"

export GDK_BACKEND=x11

# --- Added for zathura/vimtex over SSH ---
if [[ -n "$SSH_CONNECTION" && -z "$DISPLAY" ]]; then
  export DISPLAY=:0
fi

alias disp0='export DISPLAY=:0 && tmux set-environment -g DISPLAY :0'
alias disp10='export DISPLAY=:10 && tmux set-environment -g DISPLAY :10'

# tmux
# reportコマンド
# 使い方: report [PDFファイルパス1] [PDFファイルパス2] ...
# 例: report doc/guide.pdf my_report.pdf
report() {
    if [[ -z "$TMUX" ]]; then
        echo "Error: tmux session not found."
        return 1
    fi

    # 引数で渡されたファイル($@)をすべてバックグラウンドのzathuraで開く
    for file in "$@"; do
        if [[ -f "$file" ]]; then
            nohup zathura "$file" >/dev/null 2>&1 &
        else
            echo "Warning: File '$file' not found."
        fi
    done

    # ------------------------------------
    # Tmux ペイン構築 (上80% nvim / 下20% copilot)
    # ------------------------------------
    
    # 1. 上下分割 (下20%)
    tmux split-window -v -l 20% || return

    # --- 下段: Copilot Agent ---
    tmux send-keys "copilot" C-m

    # 2. 上段に戻る
    tmux select-pane -U

    # --- 上段: Neovim ---
    tmux send-keys "nvim" C-m
}

# WezTerm OSC 7 support for CWD inheritance
function wezterm_osc7 {
  if [[ -n "$TMUX" ]]; then
    print -Pn "\ePtmux;\e\e]7;file://%m%d\e\\\e\\"
  else
    print -Pn "\e]7;file://%m%d\e\\"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd wezterm_osc7