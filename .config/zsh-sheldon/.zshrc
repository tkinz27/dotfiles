setopt share_history

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

# eval "$(starship init zsh)"

bindkey -e
bindkey '^ ' autosuggest-accept

[ -f ~/.localrc ] && source ~/.localrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
