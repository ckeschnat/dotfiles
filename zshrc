# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
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
export PAGER=less

bindkey '\es' push-line-or-edit

setopt interactive_comments

source ~/.sh_aliases

if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
    source /usr/local/share/chruby/chruby.sh
fi

if [[ -f /usr/local/share/chruby/auto.sh ]]; then
    source /usr/local/share/chruby/auto.sh
fi
