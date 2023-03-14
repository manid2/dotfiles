# put all user local apps in this script.
if [ -f ~/.local/bin/user-local-apps ]; then
	# shellcheck disable=SC1090
	source ~/.local/bin/user-local-apps
fi
