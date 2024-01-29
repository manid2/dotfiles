# Relative symbolic links

lnr () {
	local opt="$1"
	local rl_dst="$2"
	local src="$3"
	local dst="$4"
	ln "$opt" "$(realpath --relative-to="$rl_dst" "$src")" "$dst"
}

lnr_rld () {
	lnr "$1" "$3" "$2" "$3"
}

lnr_bin () {
	lnr_rld "$1" "$2" "$HOME/.local/bin"
}

lnr_target () {
	local target="$3"
	if [ -d "$target" ]; then
		lnr_rld "$1" "$2" "$target"
	else
		local tdir="${target%/*}"
		mkdir -pv "$tdir"
		lnr "$1" "$tdir" "$2" "$target"
	fi
}

lnr_dir () {
	for file in "$2"/*;
	do
		lnr_rld "$1" "$file" "$3"
	done
}

alias lnrs='lnr -s '
alias lnrsf='lnr -sf '
alias lnrb='lnr_bin -s '
alias lnrbf='lnr_bin -sf '
alias lnrt='lnr_target -s '
alias lnrtf='lnr_target -sf '
alias lnrd='lnr_dir -s '
alias lnrdf='lnr_dir -sf '
