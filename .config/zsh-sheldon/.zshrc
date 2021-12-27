setopt share_history

for file in ~/.config/bash/*; do
    [ "$file" != "powerline" ] && source ${file}
done

source <(sheldon source)

#####################################################################
# completions
#####################################################################

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

# eval "$(starship init zsh)"

bindkey -e
bindkey '^ ' autosuggest-accept

[ -f ~/.localrc ] && source ~/.localrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
fpath=(${ZDOTDIR:-~}/.zsh_functions $fpath)

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
