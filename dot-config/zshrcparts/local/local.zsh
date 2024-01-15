# shellcheck shell=bash disable=all
# source shell common local settings
if [ -f ~/.config/shellcommon/local/local.sh ]; then
	source ~/.config/shellcommon/local/local.sh
fi

# add user local bin path
path=($HOME/.local/bin $path)
