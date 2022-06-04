#!/usr/bin/env sh

plugins=(
git
my
)

# Source all plugins
for plugin in "${plugins[@]}"; do
	if [ -f ~/.config/shellcommon/plugins/$plugin/$plugin.plugin.sh ]; then
		source ~/.config/shellcommon/plugins/$plugin/$plugin.plugin.sh
	fi
done
