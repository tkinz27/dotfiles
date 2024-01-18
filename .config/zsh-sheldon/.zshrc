setopt share_history

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

for file in ~/.config/bash/*; do
    [ "$file" != "powerline" ] && source ${file}
done

[ "$(uname -s)" = "Darwin" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# if test -n "$KITTY_INSTALLATION_DIR"; then
#     export KITTY_SHELL_INTEGRATION="enabled"
#     autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
#     kitty-integration
#     unfunction kitty-integration
# fi

source <(sheldon source)

#####################################################################
# completions
#####################################################################

fpath=(${ZDOTDIR:-~}/.zsh_functions $fpath)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${ZDOTDIR:-~}/cache

autoload -Uz compinit
compinit -C

#####################################################################
# bindings
#####################################################################
#
autoload -U select-word-style
select-word-style bash

bindkey -e
bindkey '^ ' autosuggest-accept


[ -f ~/.localrc ] && source ~/.localrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
