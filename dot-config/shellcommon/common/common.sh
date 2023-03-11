# shellcheck shell=bash disable=SC2034
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
