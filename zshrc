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

[[ -f ~/.sh_aliases ]] && source ~/.sh_aliases
[[ -f ~/.private_aliases ]] && source ~/.private_aliases
export PATH=/usr/local/heroku/bin:$HOME/bin:$PATH

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
    proj=$(ls ~/code | selecta)
    if [[ -n "$proj" ]]; then
        cd ~/code/$proj
    fi
}

# Search zsh stuff easily
# http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html
zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

vman() {
  vim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
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

# -----------------------------------------------
# Prompt
# -----------------------------------------------
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

# -----------------------------------------------
# git prompt
# https://gist.github.com/joshdick/4415470
# -----------------------------------------------

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {
    # Compose this value via multiple conditional appends.
    local GIT_STATE=""

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi

    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi

    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    fi

    if ! git diff --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    fi

    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi
}

# If inside a Git repository, print its branch and state
git_prompt_string() {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}
# End git prompt
# -----------------------------------------------

function setprompt() {
    # http://eseth.org/2009/nethack-term.html
    local -a lines infoline
    local x i filler i_width i_pad

    ### First, assemble the top line
    # Current dir; show in yellow if not writable
    # Git stuff
    [[ -w $PWD ]] && infoline+=( "%(#.${red}.${green})" ) || infoline+=( ${yellow} )
    infoline+=( "%~${reset} $(git_prompt_string)" )

    # Battery status
    infoline+=$(battery-status)

    # Username & host
    infoline+=( "${magenta}%n" )
    [[ -n $SSH_CLIENT ]] && infoline+=( "@%m" )
    infoline+=( " ${yellow}%*${reset}" )

    i_width=${(S)infoline//\%\{*\%\}} # search-and-replace color escapes
    i_width=${#${(%)i_width}} # expand all escapes and count the chars

    filler="%(#.${red}.${green})${(l:$(( $COLUMNS - $i_width ))::.:)}${reset}"
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
# -----------------------------------------------
# end Prompt
# -----------------------------------------------

TERM=xterm-256color
if [ -d $HOME/.pyenv/bin/ ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi
if type keychain > /dev/null;  then
    eval $(keychain --eval --agents ssh -Q --quiet ck)
fi

# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command.
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^S" "insert-selecta-path-in-command-line"

[[ -f ~/.taskconfig/bugwarriorrc ]] && export BUGWARRIORRC=~/.taskconfig/bugwarriorrc
# CA for bugwarrior/jira
[[ -f /usr/share/ca-certificates/extra/payone_office_ca.crt ]] && export REQUESTS_CA_BUNDLE=/usr/share/ca-certificates/extra/payone_office_ca.crt
