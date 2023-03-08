# shellcheck shell=bash disable=SC1090
# zsh completions file, to be sourced into ~/.zshrc

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# enable bash compatible completions for zsh
autoload -Uz bashcompinit
bashcompinit

# select from menu of completion matches
zstyle ':completion:*:*:*:*:*' menu select
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# ignore c object files for vim completion
# FIXME: ignore these file patterns '*.o-*'
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.o'

# Take advantage of $LS_COLORS for completion as well
# shellcheck disable=2296
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# source fzf auto completions
if [ -f ~/.vim/plugged/fzf/shell/completion.zsh ]; then
	source ~/.vim/plugged/fzf/shell/completion.zsh
fi

# source user created completion scripts
for comp_file in ~/.local/share/zsh/user-completions/_*; do
    if [ -f "$comp_file" ]; then
        source "$comp_file"
    fi
done

# map custom commands to matching command completions
compdef vman="man"
compdef nman="man"
compdef yman="man"
compdef ysdo="sudo"
