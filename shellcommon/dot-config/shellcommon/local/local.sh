# add env variables needed by some useful tools
export FZF_DEFAULT_COMMAND='fd'
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# put all user local apps in this script.
if [ -f ~/.local/bin/user-local-apps ]; then
	source ~/.local/bin/user-local-apps
fi
