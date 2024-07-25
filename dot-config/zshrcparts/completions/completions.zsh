# shellcheck shell=bash disable=SC1090
# zsh completions file, to be sourced into ~/.zshrc

# select from menu of completion matches
zstyle ':completion:*:*:*:*:*' menu select

# ignore c object files for vim completion
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.o'

# complete make tatgets using make command
zstyle ':completion::complete:make:*:targets' call-command true

# Take advantage of $LS_COLORS for completion as well
# shellcheck disable=2296
zstyle ':completion:*' list-colors ''

if [ -x /usr/bin/dircolors ]; then
	zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
	zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# source bash style completion scripts
for comp_file in ~/.local/share/zsh/user-completions/*.zsh; do
	if [ -f "$comp_file" ]; then
		source "$comp_file"
	fi
done

# add zsh style completion scripts to fpath
# This is required for completion scripts not wrapped in functions.
# Use '<file>.zsh' file name pattern for these kind of completion scripts.
fpath+=~/.local/share/zsh/user-completions/

# keep this after adding user completion scripts
# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# enable bash compatible completions for zsh
autoload -Uz bashcompinit
bashcompinit

# map custom commands to matching command completions
compdef vman="man"
compdef nman="man"
compdef yman="man"
compdef ysdo="sudo"
