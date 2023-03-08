# add env variables needed by some useful tools
# TODO: Check if `fd` and `ripgrep` are available.
export FZF_DEFAULT_COMMAND='fd'
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# put all user local apps in this script.
if [ -f ~/.local/bin/user-local-apps ]; then
	# shellcheck disable=SC1090
	source ~/.local/bin/user-local-apps
fi
