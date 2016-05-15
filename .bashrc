#!/bin/sh

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# User can cd into vars
shopt -s cdable_vars

# Allow minor mispelling of directory names with 'cd'
shopt -s cdspell

# Bash includes filenames beginning with a '.' in the results of filename expansion
shopt -s dotglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

set history = 2000

umask 0002

for file in $(ls ~/.config/bash); do
    source ~/.config/bash/${file}
done

# Source local settings
[ -r ~/.localrc ] && source ~/.localrc

unset file

export PATH="$PATH:$HOME/.rvm/scripts/rvm" # Add RVM to PATH for scripting
