# About:
#
# view man pages using vim as a pager

# Note:
#
# To make this work ':MANPAGER' and ':Man' commands must be available they are
# shipped with the default vim distribution if not shipped then download them
# from github and save it to user vim run time directories i.e.
# '~/.vim/{ftplugin,plugin}'

# See:
#
# vim help docs for ':h man' and ':h manpager'
# * https://vimhelp.org/filetype.txt.html#man.vim
# * https://vimhelp.org/filetype.txt.html#manpager.vim

# Credits:
#
# This function is taken from this repository.
# https://github.com/jez/vim-superman/blob/master/bin/vman
#
# It is modified to use the shipped ':MANPAGER' command from command line.
# Also avoids exiting current shell and runs vim silently.
#
# The command line completion code snippet are also taken from there for zsh
# and bash.

_pre_man () {
	local _cmd=$1; shift;
	local _msg=''
	local _ret=0

	if [ $# -eq 0 ]; then
		_msg=$(man 2>&1)
		_ret=$?
	else
		_msg=$(man -w "$@" 2>&1)
		_ret=$?
	fi

	if [ $_ret -ne 0 ]; then
		echo ${_msg/man /$_cmd }
	fi

	return $_ret
}

vman () {
	_pre_man "$0" "$@"
	local _ret=$?
	if [ $_ret -eq 0 ]; then
		vim -M +MANPAGER <(man "$@")
		_ret=$?
	fi
	return $_ret
}

yman () {
	_pre_man "$0" "$@"
	local _ret=$?
	if [ $_ret -eq 0 ]; then
		local _man_cmd=$([ -n "$2" ] &&
			echo "man:$2($1)" || echo "man:$1");

		yelp "$_man_cmd" 2>/dev/null &
		_ret=$?
	fi
	return $_ret
}
