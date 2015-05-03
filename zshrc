# Auto-tmux in SSH
if [ -n "$SSH_CLIENT" ]; then
    if [ "$PS1" != "" -a -z "$TMUX" -a "${SSH_TTY:-x}" != x ]; then
        command -v tmux 2>&1 && ((tmux ls | grep -vq attached && tmux at) || tmux new-session) && exit 0
        echo "Tmux failed! continuing with normal startup"
    else
        [[ -f /var/run/motd.dynamic ]] && cat /var/run/motd.dynamic
    fi
fi


# Basic setup
ZSH_DIR=$HOME/.zsh

HISTFILE=$ZSH_DIR/history
HISTORY_BASE=$ZSH_DIR/per-dir-history
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=10000
SAVEHIST=10000

setopt extendedglob
setopt NO_HUP
unsetopt list_ambiguous
bindkey -e

zstyle :compinstall filename "$ZSH_DIR/zshrc"
CORRECT_IGNORE='_*'

autoload -Uz compinit
compinit
# _comp_options+=(globdots)

# CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"


# Oh-my-zsh
plugins=(colorize colored-man debian docker git per-directory-history rsync systemd tmuxinator z)

export ZSH=$ZSH_DIR/oh-my-zsh
ZSH_THEME="ys"
DISABLE_AUTO_UPDATE="true"
source $ZSH/oh-my-zsh.sh


# User configuration
export PATH="$HOME/.local/bin:$PATH"

function mk_prompt {
    function git_prompt_info() {
      ref=$(git symbolic-ref HEAD 2> /dev/null) || return
      echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    }

    local SHARP='%{$fg_bold[blue]%}#%{$reset_color%}'
    local USER='%(!.%{$fg[red]%}.%{$fg[cyan]%})%n%{$reset_color%}'
    local AT='%{$fg[white]%}at'
    local HOST='%{$fg[green]%}%m'
    local IN='%{$fg[white]%}in'
    local CURRENT_DIR='%{$fg_bold[yellow]%}${PWD/#$HOME/~}%{$reset_color%}'
    local TIME='%{$fg[white]%}[%*]'
    local SYMBOL='%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})$%{$reset_color%}'

    # Prompt format: \n # USER at MACHINE in DIRECTORY on git:branch [TIME] \n $
    PROMPT=$'\n'"$SHARP $USER $AT $HOST $IN $CURRENT_DIR"'$(git_prompt_info)'" $TIME"$'\n'"$SYMBOL "
}
mk_prompt

source $ZSH_DIR/aliases
source $ZSH_DIR/proxy
