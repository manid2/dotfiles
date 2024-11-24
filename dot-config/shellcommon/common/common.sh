# shellcheck shell=bash disable=SC2034,SC2059

SYS_NAME=$(uname -s)
SYS_PREFIX=/usr

if [ "$SYS_NAME" = "Darwin" ]; then
	export CLICOLOR=1
	eval "$(/opt/homebrew/bin/brew shellenv)"

	SYS_PREFIX="$(brew --prefix)"
	export HOMEBREW_NO_AUTO_UPDATE=1

	# Set locale after disabling in MacOS Terminal/iTerm2
	# This solves the issue with zsh prompt, perl warning in MacOS as
	# Linux tools don't work well with MacOS locale environment "UTF-8". 
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
fi

# Export to command line tools
if [ "$(command -v fzf)" ]; then
	if [ "$(command -v fd)" ]; then
		_fd='fd --strip-cwd-prefix'
	else
		_fd='find . -printf "%P\n"'
	fi

	export FZF_DEFAULT_COMMAND="$_fd"
	export FZF_CTRL_T_COMMAND="$_fd"
	export FZF_ALT_C_COMMAND="$_fd"
	export FZF_DEFAULT_OPTS='--no-mouse'
fi

if [ "$(command -v rg)" ]; then
	export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
fi

export MANPATH="$HOME/.local/share/man:$MANPATH"

# XDG base directories
xdg_config="${XDG_CONFIG_HOME:-$HOME/.config}"
xdg_data="${XDG_DATA_HOME:-$HOME/.local/share}"

# Workspace aliases for faster navigation
export mwp="$HOME/Documents/myworkspace"
export msp="$HOME/Downloads/softwares"

alias mwp='cd "$mwp"'
alias msp='cd "$msp"'

# nvm node version manager
export NVM_DIR="$msp/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# rvm ruby version manager
export RVM_DIR="$msp/rvm"
export rvm_path="$RVM_DIR"
[ -s "$RVM_DIR/scripts/rvm" ] && source "$RVM_DIR/scripts/rvm"
[ -s "$RVM_DIR/scripts/completion" ] && source "$RVM_DIR/scripts/completion"

# rust environment
RUST_DIR="$msp/rust"
export RUST_HOME="$RUST_DIR/.rustup"
export CARGO_HOME="$RUST_DIR/.cargo"
[ -s "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# conda environment
CONDA_DIR="$msp/conda"

# source shell common unicode characters
if [ -f ~/.config/shellcommon/common/unicode-chars.sh ]; then
	source ~/.config/shellcommon/common/unicode-chars.sh
fi

# source shell common colors
if [ -f ~/.config/shellcommon/common/colors.sh ]; then
	source ~/.config/shellcommon/common/colors.sh
fi

# source shell common functions
if [ -f ~/.config/shellcommon/common/functions.sh ]; then
	source ~/.config/shellcommon/common/functions.sh
fi

# source shell common aliases
if [ -f ~/.config/shellcommon/aliases/aliases.sh ]; then
	source ~/.config/shellcommon/aliases/aliases.sh
fi

# source shell common local settings
if [ -f ~/.config/shellcommon/local/local.sh ]; then
	source ~/.config/shellcommon/local/local.sh
fi

# source shell common plugins
if [ -f ~/.config/shellcommon/plugins/plugins.sh ]; then
	source ~/.config/shellcommon/plugins/plugins.sh
fi

# source shell common prompt
if [ -f ~/.config/shellcommon/prompt/prompt.sh ]; then
	source ~/.config/shellcommon/prompt/prompt.sh
fi
