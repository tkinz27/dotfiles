#!/bin/bash

# This script just sets up https://github.com/tkinz27/dotfiles repo as a bare repo in the home directory.
# It requires git to already be installed.
# Currently this is not an idempotent script

# To run this script in one command (requires curl and jq)
# curl -sL https://api.github.com/repos/tkinz27/dotfiles/contents/.install_dotfiles.sh \
#   | jq -r .content | base64 -d | sh -

function install_rustup {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -q -y
}

function install_ubuntu {
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo add-apt-repository -y ppa:git-core/ppa

    sudo apt update
    sudo apt install -y git neovim zsh 
}

function install_mac {
    echo "NOT IMPLEMENTED YET"
}

if [[ ! -d ~/.files ]]; then
    git clone --bare https://github.com/tkinz27/dotfiles $HOME/.files

    dotfiles() {
        git --git-dir=$HOME/.files/ --work-tree=$HOME $@
    }

    # first lets backup any existing dotfiles
    mkdir -p "${HOME}/.files.bak"
    dotfiles checkout 2>&1 > /dev/null
    if [ $? = 0 ]; then
        echo "Checked out dotfiles.";
    else
        echo "Backing up pre-existing dotfiles.";
        dotfiles checkout 2>&1 | egrep -v "^\w" | awk '{print $1}' | xargs -I{} rm {}
    fi
    dotfiles checkout
    dotfiles config status.showUntrackedFiles no
    dotfiles submodule init
    dotfiles submodule update
else
    echo "dotfiles already installed? skipping..."
fi

install_rustup

if [[ $(uname -s) == "Linux" ]]; then
    id=$(cat /etc/os-release | grep ^ID= | cut -d'=' -f 2)
    if [[ "$id" == "ubuntu" ]]; then
        install_ubuntu
    fi
elif [[ $(uname -s) == "Darwin" ]]; then
    install_mac
fi

[ -n "$(which zsh)" ] && [ "$SHELL" != "$(which zsh)" ] && chsh -s $(which zsh) ${USER}
