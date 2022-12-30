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

vman () {
	if [ $# -eq 0 ]; then
		echo "What manual page do you want?";
		return 0
	elif ! man -w "$@" > /dev/null; then
		# return if no man page found
		return 1
	fi

	vim -M +MANPAGER <(man "$@")
}
