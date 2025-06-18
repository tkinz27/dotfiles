setopt share_history

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

[ "$(uname -s)" = "Darwin" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ "$(uname -s)" = "Darwin" ] && FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

for file in ~/.config/bash/*; do
    [ "$file" != "powerline" ] && source ${file}
done

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
if [[ -d "$HOME/.pulumi/bin" && ":$PATH:" != *":$HOME/.pulumi/bin:"* ]]; then
  export PATH="$PATH:$HOME/.pulumi/bin"
fi

# --- Enforce PATH uniqueness as a final step ---
# The 'path' array is tied to $PATH in Zsh.
# Declaring it as unique (-U) processes the current $PATH, removes duplicates,
# and maintains this uniqueness.
typeset -U path
# --- End of PATH uniqueness enforcement ---
