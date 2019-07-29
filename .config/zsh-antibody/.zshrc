#!/bin/zsh

#####################################################################
# plugins
#####################################################################

source ~/.config/zsh-antibody/zsh_plugins.zsh

#####################################################################
# completions
#####################################################################

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

for file in ~/.config/bash/*; do
    [ "$file" != "powerline" ] && source ${file}
done

bindkey '^ ' autosuggest-accept

[ -f ~/.localrc ] && source ~/.localrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
