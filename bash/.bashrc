# /etc/bash.bashrc
#
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output. So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

# store multiline commands as one line in the history
shopt -s cmdhist

export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
export HISTSIZE="no numeric value => infinite"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S - "

#case ${TERM} in
#    xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
#        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'history -n; history -a;printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
#        ;;
#    screen)
#        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'history -n; history -a;printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
#        ;;
#esac

# fortune is a simple program that displays a pseudorandom message
# from a database of quotations at logon and/or logout.
# Type: "pacman -S fortune-mod" to install it, then uncomment the
# following line:

# [[ "$PS1" ]] && /usr/bin/fortune

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS. Try to use the external file
# first to take advantage of user additions. Use internal bash
# globbing instead of external grep binary.

# sanitize TERM:
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] \
    && type -P dircolors >/dev/null \
    && match_lhs=$(dircolors --print-database)

# if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] ; then
    
    # we have colors :-)

    # Enable colors for ls, etc. Prefer ~/.dir_colors
    if type -P dircolors >/dev/null ; then
        if [[ -f ~/.dir_colors ]] ; then
            eval $(dircolors -b ~/.dir_colors)
        elif [[ -f /etc/DIR_COLORS ]] ; then
            eval $(dircolors -b /etc/DIR_COLORS)
        fi
    fi

    # PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\$\[\033[00m\] "
    # PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\]\")\$(parse_git_branch_or_tag) \$\[\033[00m\] "

    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
     
    # Colors
     
    Black="$(tput setaf 0)"
    BlackBG="$(tput setab 0)"
    DarkGrey="$(tput bold ; tput setaf 0)"
    LightGrey="$(tput setaf 7)"
    LightGreyBG="$(tput setab 7)"
    White="$(tput bold ; tput setaf 7)"
    Red="$(tput setaf 1)"
    RedBG="$(tput setab 1)"
    LightRed="$(tput bold ; tput setaf 1)"
    Green="$(tput setaf 2)"
    GreenBG="$(tput setab 2)"
    LightGreen="$(tput bold ; tput setaf 2)"
    Brown="$(tput setaf 3)"
    BrownBG="$(tput setab 3)"
    Yellow="$(tput bold ; tput setaf 3)"
    Blue="$(tput setaf 4)"
    BlueBG="$(tput setab 4)"
    LightBlue="$(tput bold ; tput setaf 4)"
    Purple="$(tput setaf 5)"
    PurpleBG="$(tput setab 5)"
    Pink="$(tput bold ; tput setaf 5)"
    Cyan="$(tput setaf 6)"
    CyanBG="$(tput setab 6)"
    LightCyan="$(tput bold ; tput setaf 6)"
    NC="$(tput sgr0)" # No Color
     
    export PS1="$LightCyan\u$White:$LightRed\w$Yellow\$(parse_git_branch) \d \t $LightGreen\n λ \[\e[0m\]"

    # Use this other PS1 string if you want \W for root and \w for all other users:
    # PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h\[\033[01;34m\] \W'; else echo '\[\033[01;32m\]\u@\h\[\033[01;34m\] \w'; fi) \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\$\[\033[00m\] "

# else
# 
#     # show root@ when we do not have colors
# 
#     PS1="\u@\h \w \$([[ \$? != 0 ]] && echo \":( \")\$ "
# 
#     # Use this other PS1 string if you want \W for root and \w for all other users:
#     # PS1="\u@\h $(if [[ ${EUID} == 0 ]]; then echo '\W'; else echo '\w'; fi) \$([[ \$? != 0 ]] && echo \":( \")\$ "
# 
# fi

if [ -f ~/.sh_aliases ]; then
    . ~/.sh_aliases
fi

PS2="> "
PS3="> "
PS4="+ "

# Try to keep environment pollution down, EPA loves us.
unset safe_term match_lhs

# Try to enable the auto-completion (type: "pacman -S bash-completion" to install it).
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

parse_git_tag () {
  git describe --tags 2> /dev/null
}

parse_git_branch_or_tag() {
  local OUT="$(parse_git_branch)"
  if [ "$OUT" == " ((no branch))" ]; then
    OUT="($(parse_git_tag))";
  fi
  echo $OUT
}

if [ -f /usr/local/share/chruby/chruby.sh ]; then
    source /usr/local/share/chruby/chruby.sh
fi

if [ -f /usr/local/share/chruby/auto.sh ]; then
    source /usr/local/share/chruby/auto.sh
fi

# Run twolfson/sexy-bash-prompt
# . ~/.bash_prompt

# Launch Zsh
if [ -t 1 ]; then
  exec zsh
fi
