# zsh completions file, to be sourced into ~/.zshrc

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# enable bash compatible completions for zsh
autoload -Uz bashcompinit
bashcompinit

zstyle ':completion:*:*:*:*:*' menu select
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# source user created completion scripts
for comp_file in ~/.local/share/zsh/user-completions/_*; do
    if [ -f $comp_file ]; then
        source $comp_file
    fi
done
