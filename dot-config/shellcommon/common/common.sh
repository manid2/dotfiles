# shellcheck shell=bash disable=SC2034,SC2059

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
