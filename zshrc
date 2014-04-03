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
setopt menu_complete
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
function p() {
    proj=$(ls ~/projects | selecta)
    if [[ -n "$proj" ]]; then
        cd ~/projects/$proj
    fi
}
#------------------------------

autoload -U promptinit
promptinit
prompt adam2

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

