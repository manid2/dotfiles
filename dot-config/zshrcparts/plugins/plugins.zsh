# shellcheck shell=bash disable=all
# zsh plugins file, to be sourced into ~/.zshrc

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	# change suggestion color
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi


# Source command-not-found plugin if available
if [ -f /etc/zsh_command_not_found ]; then
	source /etc/zsh_command_not_found
fi

source_plugins "zsh"
