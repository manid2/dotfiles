# shellcheck shell=bash disable=all
# zsh plugins file, to be sourced into ~/.zshrc

enable_plugins() {
	local plugin_dirs=(
		"$HOME/.local/share"
		"$SYS_PREFIX/share"
	)

	local plugins=(
		"zsh-autosuggestions/zsh-autosuggestions.zsh"
		"zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	)

	for plugin_dir in "${plugin_dirs[@]}"; do
		[ -d "$plugin_dir" ] || continue

		for plugin in "${plugins[@]}"; do
			[ -f "$plugin_dir/$plugin" ] && source "$plugin_dir/$plugin"
		done
		return 0
	done
	return 1
}

enable_command_not_found() {
	if [ -f /etc/zsh_command_not_found ]; then
		source /etc/zsh_command_not_found
		return 0
	fi

	if [ "$SYS_NAME" = "Darwin" ]; then
		HB_CNF_HANDLER="$(brew --repository)/Library/Homebrew/command-not-found/handler.sh"
		[ -f "$HB_CNF_HANDLER" ] && source "$HB_CNF_HANDLER"
	fi
}

init_zoxide() {
	command -v zoxide >/dev/null 2>&1 || return 0
	eval "$(zoxide init zsh)"
}

init_conda() {
	command -v conda >/dev/null 2>&1 || return 0

	conda config --set changeps1 False
	conda config --set auto_activate False
	eval "$(conda 'shell.zsh' 'hook')"
	conda deactivate
	#conda env config vars set VIRTUAL_ENV=$CONDA_DEFAULT_ENV
}

enable_plugins
enable_command_not_found
init_zoxide
init_conda
