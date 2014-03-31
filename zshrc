# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt nomatch notify
unsetopt appendhistory autocd beep extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/var/www/ckeschnat/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit
prompt adam2

export EDITOR=vim
export VISUAL=$EDITOR

bindkey '\es' push-line-or-edit

source ~/.sh_aliases

if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
    source /usr/local/share/chruby/chruby.sh
fi

if [[ -f /usr/local/share/chruby/auto.sh ]]; then
    source /usr/local/share/chruby/auto.sh
fi
