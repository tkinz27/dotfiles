#!/bin/sh

# This script just sets up https://github.com/tkinz27/dotfiles repo as a bare repo in the home directory.
# It requires git to already be installed.
# Currently this is not an idempotent script

# To run this script in one command (requires curl and jq)
# curl -sL https://api.github.com/repos/tkinz27/dotfiles/contents/.install_dotfiles.sh \
#   | jq -r .content | base64 -d | sh -

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
