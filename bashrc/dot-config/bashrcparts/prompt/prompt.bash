# bash prompt file, to be sourced into ~/.bashrc

# Shell common colors
if [ -f ~/.config/shellcommon/common/colors.sh ]; then
	source ~/.config/shellcommon/common/colors.sh
fi

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# Check if terminal supports color prompt
case "$TERM" in
	xterm-color | *-256color)
		color_prompt='yes'
		;;
esac

# Reset the color variables when terminal has no support.
if [ "$color_prompt" != 'yes' ]; then
	MAGENTA=''
	GREEN=''
	BLUE=''
	RESET=''
fi

# This function executes before displaying the prompt.
prompt_command () {
	# this must be the first line to capture exit code of last executed
	# command.
	local _proc_exit=$?

	# initliaze local ps1
	local _ps1=''

	# add chroot if available
	if  [ -n "$debian_chroot" ]; then
		_ps1+="$BLUE(${debian_chroot:+($debian_chroot)})$RESET"
		_ps1+="$BLUE-$RESET"
	fi

	# add user, host and current working directory
	_ps1+="$GREEN[\u@\h:\W]$RESET"
	_ps1+="$BLUE-$RESET"

	# add process exit code
	if [ "$_proc_exit" -eq 0 ]; then
		_ps1+="$GREEN[$_proc_exit]$RESET"
		_ps1+="$BLUE-$RESET"
	else
		_ps1+="$MAGENTA[$_proc_exit]$RESET"
		_ps1+="$BLUE-$RESET"
	fi

	# add git status prompt
	if [ "$(command -v __git_ps1)" ]; then
		local _gps1=$(__git_ps1 '(%s)')
		if  [ -n "$_gps1" ]; then
			_ps1+="$BLUE$_gps1$RESET"
			_ps1+="$BLUE-$RESET"
		fi
	fi

	# add user prompt character '$'
	_ps1+="$VIOLET$ $RESET"

	# set terminal title
	local _xterm_title=''
	case "$TERM" in
		xterm* | rxvt*)
			_xterm_title='\[\e]0;\u@\h:\W\a\]'
			;;
		*)
			_xterm_title=''
			;;
	esac

	# set the prompt environment variables
	PS1="${_xterm_title}${_ps1}"
	PS2='> '
	PS4='+ '
}

# `trap` with DEBUG manipulates prompt attributes on output from bash commands
#trap 'tput sgr0' DEBUG

# Bash always executes the contents of this environment variable here it is
# 'prompt_command ()' just before displaying the prompt.
export PROMPT_COMMAND=prompt_command

# Shell common prompt configs
if [ -f ~/.config/shellcommon/prompt/prompt.sh ]; then
	source ~/.config/shellcommon/prompt/prompt.sh
fi
