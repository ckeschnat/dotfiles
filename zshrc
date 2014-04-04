HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

bindkey -e

autoload -Uz compinit
compinit

export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less

bindkey '\es' push-line-or-edit
# Make S-Tab work
bindkey '^[[Z' reverse-menu-complete
# Enable globs in history search
bindkey "^R" history-incremental-pattern-search-backward

setopt ksh_option_print
setopt interactive_comments
setopt append_history
setopt hist_ignore_dups
setopt no_autocd
setopt no_beep
setopt nomatch
setopt notify
setopt prompt_subst
setopt auto_pushd
setopt pushd_ignore_dups
setopt extended_glob
setopt complete_in_word

DIRSTACKSIZE=5

source ~/.sh_aliases
export PATH=$HOME/bin/:$PATH

if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
    source /usr/local/share/chruby/chruby.sh
fi

if [[ -f /usr/local/share/chruby/auto.sh ]]; then
    source /usr/local/share/chruby/auto.sh
fi

#------------------------------
# ShellFuncs
#------------------------------
# -- coloured manuals
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# From Gary Bernhardt
function pp() {
    proj=$(ls ~/projects | selecta)
    if [[ -n "$proj" ]]; then
        cd ~/projects/$proj
    fi
}

# Search zsh stuff easily
# http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html
zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

# automatically rename tmux windows to hostnames after ssh
# and back after disconnecting
ssh() {
    [[ ! -z "$TMUX" ]] && tmux rename-window "$*"
    command ssh "$@"
    [[ ! -z "$TMUX" ]] && tmux rename-window "zsh"
}
#------------------------------

# Show type of completion and group by it
zstyle ':completion:*:descriptions' format %B%d%b
zstyle ':completion:*' group-name ''
# Show descriptions for options
zstyle ':completion:*' verbose
# Use menu when completing
zstyle ':completion*:default' menu 'select=0'
# Select an item from a menu without closing the menu
zmodload zsh/complist
bindkey -M menuselect '\C-o' accept-and-menu-complete
# Approximate completion
zstyle ':completion:::::' completer _complete _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) )'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# Complete lower case case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Partial completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'm:{a-zA-Z}={A-Za-z}'
# Ignore current path when complete ../
zstyle ':completion:*' ignore-parents parent pwd

# Use bash style words (e.g. for backward-kill-word)
autoload -U select-word-style
select-word-style bash

# Complete only hostnames for hosts in .ssh/config and the machine connected from
# From https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=430146#20
[[ -f ~/.ssh/config ]] && hosts=(${${${(M)${(f)"$(<~/.ssh/config)"}:#Host*}#Host }:#*\**})
[[ ! -z $hosts ]] && zstyle ':completion:*:hosts' hosts $hosts ${REMOTEHOST:-${SSH_CLIENT%% *}}

# Use Ctrl-z to bring vim to foreground
foreground-vi() {
  fg %vi
}
zle -N foreground-vi
bindkey '^Z' foreground-vi


#------------------------------
# prompt
# originally from https://gist.github.com/mislav/1712320
#------------------------------
autoload colors; colors;

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# show git branch/tag, or name-rev if on detached head
parse_git_branch() {
    (command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

# show red star if there are uncommitted changes
parse_git_dirty() {
    if command git diff-index --quiet HEAD 2> /dev/null; then
        echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    else
        echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    fi
}

# if in a git repo, show dirty indicator + git branch
git_custom_status() {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${git_where#(refs/heads/|tags/)}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

RPS1='$(git_custom_status) %{$fg[magenta]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[yellow]%}%T%{$reset_color%}'

# basic prompt on the left
PROMPT='%{$fg[cyan]%}%~% %(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
#------------------------------
