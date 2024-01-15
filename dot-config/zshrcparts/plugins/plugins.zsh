# shellcheck shell=bash disable=all
# zsh plugins file, to be sourced into ~/.zshrc

# Source command-not-found plugin if available
if [ -f /etc/zsh_command_not_found ]; then
	source /etc/zsh_command_not_found
fi

source_plugins "zsh"
