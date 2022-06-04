# source shell common local settings
if [ -f ~/.config/shellcommon/local/local.sh ]; then
	source ~/.config/shellcommon/local/local.sh
fi

# add user local bin path to PATH
export PATH="$HOME/.local/bin:$PATH"
