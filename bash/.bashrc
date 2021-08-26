#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Editor
export EDITOR='vim'

# Locale
#export LC_ALL='en_US.utf8'
#export LANG='en_US.UTF-8'
#export LANGUAGE='en_US.UTF-8'
