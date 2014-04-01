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

source ~/.sh_aliases

if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
    source /usr/local/share/chruby/chruby.sh
fi

if [[ -f /usr/local/share/chruby/auto.sh ]]; then
    source /usr/local/share/chruby/auto.sh
fi
