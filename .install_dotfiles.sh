#!/bin/sh

# This script just sets up https://github.com/tkinz27/dotfiles repo as a bare repo in the home directory.
# It requires git zsh curl to already be setup.
# Currently this is not an idempotent script

git clone --bare https://github.com/tkinz27/dotfiles $HOME/.files

dotfiles() {
    git --git-dir=$HOME/.files/ --work-tree=$HOME $@
}

# first lets backup any existing dotfiles
mkdir -p $HOME/.files.bak
dotfiles checkout 2>&1 > /dev/null
if [ $? = 0 ]; then
    echo "Checked out dotfiles.";
else
    echo "Backing up pre-existing dotfiles.";
    dotfiles checkout 2>&1 | egrep -v "^\w" | awk '{print $1}' | xargs -I{} rm {}
fi
dotfiles checkout
dotfiles config status.showUntrackedFiles no
