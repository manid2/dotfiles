# shellcheck disable=SC1090,SC1091
# shell common plugins
plugins=(
git
my
vman
)

# Source all plugins
for plugin in "${plugins[@]}"; do
	if [ -f ~/.config/shellcommon/plugins/"$plugin"/"$plugin".plugin.sh ]; then
		source ~/.config/shellcommon/plugins/"$plugin"/"$plugin".plugin.sh
	fi
done
