find_plugins () {
	local pdir=~/.config/"$1"/plugins/
	find "$pdir" -maxdepth 1 -not -path "$pdir" -type d \
	     -printf "%p\n" 2>/dev/null | sort
}

source_plugins () {
	local shell="$1"
	local psfx="${shell}"
	local pdir="${shell}rcparts"

	if [ "$shell" = "sh" ]; then
		pdir="shellcommon"
	fi

	while IFS= read -r ppath;
	do
		local pname="$(basename "$ppath")"
		local pfile="$ppath/$pname.plugin.$psfx"

		if [ -f "$pfile" ]; then
			source "$pfile"
		fi
	done < <(find_plugins "$pdir")
}
