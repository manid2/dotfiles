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

lnr_lib () {
	lnr_rld "$1" "$2" "$HOME/.local/lib"
}

lnr_man () {
	lnr_rld "$1" "$2" "$HOME/.local/share/man/man$3"
}

lnr_man1 () {
	lnr_man "$1" "$2" "1"
}

lnr_share () {
	lnr_rld "$1" "$2" "$HOME/.local/share"
}

lnr_dir () {
	for file in "$2"/*;
	do
		lnr_rld "$1" "$file" "$3"
	done
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

lnr_target_share () {
	local t=$(echo "$2" | sed "s/.*\/share/share/g")
	t="$HOME/.local/$t"
	lnr_target "$1" "$2" "$t"
}

lnr_target_share_all () {
	while IFS= read -r file;
        do
		lnr_target_share "$1" "$file"
	done < <(find "$2" -type f -printf "%p\n" | sort)
}

alias lnrs='lnr -s '
alias lnrsf='lnr -sf '
alias lnrb='lnr_bin -s '
alias lnrbf='lnr_bin -sf '
alias lnrl='lnr_lib -s '
alias lnrlf='lnr_lib -sf '
alias lnrm='lnr_man1 -s '
alias lnrmf='lnr_man1 -sf '
alias lnrsh='lnr_share -s '
alias lnrshf='lnr_share -sf '
alias lnrd='lnr_dir -s '
alias lnrdf='lnr_dir -sf '
alias lnrt='lnr_target -s '
alias lnrtf='lnr_target -sf '
alias lnrtsh='lnr_target_share -s '
alias lnrtshf='lnr_target_share -sf '
alias lnrtsa='lnr_target_share_all -s '
alias lnrtsaf='lnr_target_share_all -sf '
