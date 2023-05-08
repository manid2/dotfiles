# shellcheck shell=bash disable=SC2034,SC2059

# Export to command line tools
if [ "$(command -v fzf)" ]; then
	_fd='fd --strip-cwd-prefix'
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

msg_fmt () {
	local file="$1"; shift
	local msg="$*"
	printf "${msg}\n" >> "$file"
}

# Workspace aliases for faster navigation
mwp="$HOME/Documents/myworkspace"
export mwp

alias mwp='cd "$mwp"'
