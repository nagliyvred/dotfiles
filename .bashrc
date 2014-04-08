#!/bin/bash

export HISTCONTROL=erasedups
export HISTSIZE=5000
export HISTTIMEFORMAT="%F %T "

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# correct minor errors in the spelling of a directory component in a cd command
shopt -s cdspell
# save all lines of a multiple-line command in the same history entry (allows easy re-editing of multi-line commands)
shopt -s cmdhist

export TERM=xterm-256color

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_ps1 ]] && source ~/.bash_ps1
#[[ -f ~/.bash_completion ]] && source ~/.bash_completion

for file in  ~/.dotfiles-ignore/*.sh; do source $file; done

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

