# shellcheck shell=bash disable=all
# zsh plugins file, to be sourced into ~/.zshrc

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	# change suggestion color
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi


# enable command-not-found
if [ -f /etc/zsh_command_not_found ]; then
	source /etc/zsh_command_not_found
fi

# enable zoxide
if [ "$(command -v zoxide)" ]; then
	eval "$(zoxide init zsh)"
fi

source_plugins "zsh"
