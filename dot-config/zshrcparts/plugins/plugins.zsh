# shellcheck shell=bash disable=all
# zsh plugins file, to be sourced into ~/.zshrc

# Source command-not-found plugin if available
if [ -f /etc/zsh_command_not_found ]; then
	source /etc/zsh_command_not_found
fi

# zsh plugins
plugins=(
fzf
)

# Source all plugins
for plugin in "${plugins[@]}"; do
	pfile=~/.config/zshrcparts/plugins/"$plugin"/"$plugin".plugin.zsh
	if [ -f $pfile ]; then
		source $pfile
	fi
done
