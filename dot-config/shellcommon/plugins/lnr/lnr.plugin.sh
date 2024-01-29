# Relative symbolic links

lnr () {
	local opt="$1"
	local rl_dst="$2"
	local src="$3"
	local dst="$4"
	ln "$opt" "$(realpath --relative-to="$rl_dst" "$src")" "$dst"
}

_lnrb () {
	local opt="$1"
	local src="$2"
	local dst="$HOME/.local/bin"
	lnr "$opt" "$dst" "$src" "$dst"
}

_lnrt () {
	local opt="$1"
	local src="$2"
	local dst="$3"

	if [ -d "$dst" ]; then
		lnr "$opt" "$dst" "$src" "$dst"
	else
		lnr "$opt" "${dst%/*}" "$src" "$dst"
	fi
}

_lnrd () {
	local opt="$1"
	local sdir="$2"
	local ddir="$3"

	for sfile in "$sdir"/*;
	do
		lnr "$opt" "$ddir" "$sfile" "$ddir"
	done
}

alias lnrs='lnr -s '
alias lnrsf='lnr -sf '
alias lnrb='_lnrb -s '
alias lnrbf='_lnrb -sf '
alias lnrt='_lnrt -s '
alias lnrtf='_lnrt -sf '
alias lnrd='_lnrd -s '
alias lnrdf='_lnrd -sf '
