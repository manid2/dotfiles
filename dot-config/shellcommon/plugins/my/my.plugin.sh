# shellcheck disable=SC1090,SC1091
# source shell common file
if [ -f ~/.config/shellcommon/common/common.sh ]; then
	source ~/.config/shellcommon/common/common.sh
fi

# --- aliases ---
# workspace aliases
# shellcheck disable=2154
export mydp="$mwp/mydocs"
export myrp="$mwp/myrepos"
export mybp="$myrp/manid2.gitlab.io"

alias mydp='cd "$mydp"'
alias myrp='cd "$myrp"'
alias mybp='cd "$mybp"'

lnr () {
	local opt="$1"
	local rl_dst="$2"
	local src="$3"
	local dst="$3"
	ln "$opt" "$(realpath --relative-to="$rl_dst" "$src")" "$dst"
}
}

alias lnrs='lnr -s '
alias lnrsf='lnr -sf '

slugify () {
	local _data=''
	if test -z "$1"; then
		while read -r data; do
			_data="$data"
		done
	else
		_data="$1"
	fi

	echo "$_data" | sed -E 's/[~\^]+//g' | sed -E 's/[^a-zA-Z0-9]+/-/g'
}

slugifyi () {
	slugify "$1" | tr '[:upper:]' '[:lower:]'
}

opens () {
	open "$1" 2>/dev/null
}

aliasg () {
	alias | grep --color=always "$@" | less -r -F
}

# ssh aliases
alias ssdeb01='ssh mkdeb01@mk-deb-001'

# nvm node version manager
export NVM_DIR="$myrp/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
