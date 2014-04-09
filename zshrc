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
export PATH=$HOME/bin:$PATH

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
    type selecta >/dev/null 2>&1 || { echo >&2 "Selecta is missing, get it from https://github.com/garybernhardt/selecta"; return 1; }
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
    [[ ! -z "$TMUX" ]] && tmux rename-window ${${(P)#}%.*}
    command ssh "$@"
    [[ ! -z "$TMUX" ]] && tmux rename-window "zsh"
    return 0
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
# Prompt
#------------------------------
autoload -U colors && colors

reset="%{${reset_color}%}"
white="%{$fg[white]%}"
gray="%{$fg_bold[black]%}"
green="%{$fg_bold[green]%}"
red="%{$fg[red]%}"
yellow="%{$fg[yellow]%}"
cyan="%{$fg[cyan]%}"
magenta="%{$fg[magenta]%}"

function battery-status() {
    # acpi must be present
    type acpi >/dev/null 2>&1 || return
    local battery_state
    battery_state=$(acpi | grep -oP "[0-9]*(?=%)")
    [[ -z $battery_state ]] && return
    [[ $battery_state -ge 50 ]] && echo "${green}${battery_state}%%${reset} " && return
    [[ $battery_state -ge 20 ]] && echo "${yellow}${battery_state}%%${reset} " && return
    echo "${red}${battery_state}%%${reset} " && return
}

function __git_prompt {
    local DIRTY=$yellow
    local CLEAN=$green
    local UNMERGED=$red
    local RESET=$reset

    # exit when not inside git repository
    command git rev-parse --is-inside-work-tree &>/dev/null || return

    echo -n "["
    if [[ `git ls-files -u >& /dev/null` == '' ]]
    then
        git diff --quiet >& /dev/null
        if [[ $? == 1 ]]
        then
            echo -n $DIRTY
        else
            git diff --cached --quiet >& /dev/null
            if [[ $? == 1 ]]
            then
                echo -n $DIRTY
            else
                echo -n $CLEAN
            fi
        fi
    else
        echo -n $UNMERGED
    fi
    echo -n `git branch | grep '* ' | sed 's/..//'`
    echo -n $RESET
    echo -n "]"
}

function setprompt() {
    # http://eseth.org/2009/nethack-term.html
    local -a lines infoline
    local x i filler i_width i_pad

    ### First, assemble the top line
    # Current dir; show in yellow if not writable
    # Git stuff
    [[ -w $PWD ]] && infoline+=( ${green} ) || infoline+=( ${yellow} )
    infoline+=( "%~${reset} $(__git_prompt) " )

    # Battery status
    infoline+=$(battery-status)

    # Username & host
    infoline+=( "${magenta}%n" )
    [[ -n $SSH_CLIENT ]] && infoline+=( "@%m" )
    infoline+=( " ${yellow}%*${reset}" )

    i_width=${(S)infoline//\%\{*\%\}} # search-and-replace color escapes
    i_width=${#${(%)i_width}} # expand all escapes and count the chars

    filler="%(#.${red}.${gray})${(l:$(( $COLUMNS - $i_width ))::.:)}${reset}"
    infoline[2]=( "${infoline[2]} ${filler} " )

    ### Now, assemble all prompt lines
    lines+=( ${(j::)infoline} )
    lines+=( "%(1j.${gray}%j${reset} .)%(0?.${green}.${red})%B$%b ${reset} " )


    ### Finally, set the prompt
    PROMPT=${(F)lines}
}

function precmd {
    setprompt
}
#------------------------------

TERM=xterm-256color
