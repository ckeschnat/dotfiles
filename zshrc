HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

bindkey -e

zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
compinit

export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less

bindkey '\es' push-line-or-edit

setopt kshoptionprint
setopt interactive_comments
setopt appendhistory
setopt histignoredups
setopt noautocd
setopt nobeep
setopt nomatch
setopt notify
setopt promptsubst

source ~/.sh_aliases

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

# autoload -U promptinit
# promptinit
# prompt adam2

#------------------------------
# Prompt
#------------------------------
PS1='%B%F{cyan}.%b%F{cyan}-%B%F{black}(%B%F{green}%~%B%F{black})%b%F{cyan}-------------------------------------------------------------------------------------------------------------------------------------------------------------------%B%F{black}(%b%F{cyan}%n%B%F{cyan}@%b%F{cyan}%m%B%F{black})%b%F{cyan}-
%{%}%B%F{cyan}\`-%b%F{cyan}-%B%F{white}%B%F{white}%(!.#.>) %b%f%k'
