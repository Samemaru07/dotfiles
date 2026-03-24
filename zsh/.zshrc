typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
zinit light romkatv/powerlevel10k

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

bindkey '^E' backward-kill-word
bindkey '^R' kill-word

bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\e[3~" delete-char

# Windows username (dynamic)
export WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
if [[ -n "$WIN_USER" ]]; then
  export PATH=$PATH:/mnt/c/Users/$WIN_USER/AppData/Local/Android/Sdk/platform-tools
  alias adb="/mnt/c/Users/$WIN_USER/AppData/Local/Android/Sdk/platform-tools/adb.exe"
fi

# GDK_BACKEND is set to "wayland,x11" by hyprland.conf; do not override here

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

# PATH
[ -d "/opt/nvim-linux-x86_64/bin" ]            && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
[ -d "/usr/local/go/bin" ]                      && export PATH="$PATH:/usr/local/go/bin"
[ -d "$HOME/go/bin" ]                           && export PATH="$PATH:$HOME/go/bin"
[ -d "$HOME/.cargo/bin" ]                       && export PATH="$PATH:$HOME/.cargo/bin"
[ -d "$HOME/.deno/bin" ]                        && export PATH="$PATH:$HOME/.deno/bin"
[ -d "$HOME/.local/bin" ]                       && export PATH="$PATH:$HOME/.local/bin"
[ -d "$HOME/.config/composer/vendor/bin" ]      && export PATH="$PATH:$HOME/.config/composer/vendor/bin"
[ -d "/mnt/c/tools" ]                           && export PATH="$PATH:/mnt/c/tools"
[ -d "/snap/bin" ]                              && export PATH="$PATH:/snap/bin"
[ -d "$HOME/development/flutter/bin" ] && export PATH="$PATH:$HOME/development/flutter/bin"
true

if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  fastfetch
fi
