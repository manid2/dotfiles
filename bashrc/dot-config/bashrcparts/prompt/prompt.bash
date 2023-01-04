# bash prompt file, to be sourced into ~/.bashrc

# Shell common colors
if [ -f ~/.config/shellcommon/common/colors.sh ]; then
	source ~/.config/shellcommon/common/colors.sh
fi

# Unicode characters
if [ -f ~/.config/shellcommon/common/unicode-chars.sh ]; then
	source ~/.config/shellcommon/common/unicode-chars.sh
fi

# Shell common prompt configs
if [ -f ~/.config/shellcommon/prompt/prompt.sh ]; then
	source ~/.config/shellcommon/prompt/prompt.sh
fi

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# override default virtualenv indicator in prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
venv_info=${VIRTUAL_ENV:+$(basename $VIRTUAL_ENV)}

# Check if terminal supports color prompt
case "$TERM" in
	xterm-color | *-256color)
		color_prompt='yes'
		;;
esac

# Reset the color variables when terminal has no support.
if [ "$color_prompt" != 'yes' ]; then
	MAGENTA=''
	RED=''
	GREEN=''
	BLUE=''
	YELLOW=''
	CYAN=''
	RESET=''
fi

_gps1_pre=''
_gps1_post=''

# normal user color and symbol
_user_sym='$'
_user_color=$GREEN
# root user color and symbol
if [ "$EUID" -eq 0 ]; then
	_user_sym='#'
	_user_color=$MAGENTA
fi

# Use ascii if unicode characters not supported or cause errors
# FIXME: Errors seen on FreeBSD bash when using reverse search.
if [ "$(uname -o)" = 'FreeBSD' ]; then
	uc_bdl_dr='+--'
	uc_bdl_h='-'
	uc_bdl_ur='+-'
fi

# initliaze local ps1
_ps1=''

# box start ┌──
_ps1+="$_user_color$uc_bdl_dr$uc_bdl_h$uc_bdl_h"

# add chroot if available
_ps1+="${debian_chroot:+($debian_chroot)$uc_bdl_h}"

# add venv if available
_ps1+="${venv_info:+($venv_info)$uc_bdl_h}"

# (user@host:cwd)
PROMPT_DIRTRIM=2
_ps1+="($CYAN\u$YELLOW@$CYAN\h$YELLOW:$BLUE\w$_user_color)$uc_bdl_h"

# [date time] in dd-Mon-yyyy H:M:S in 24 hr format
_ps1+="[$MAGENTA\D{%d-%b-%Y %H:%M:%S}$_user_color]$uc_bdl_h"
_gps1_pre+="$_ps1"

# add user prompt symbol '$' or '#' if root
_gps1_post+="\n$_user_color$uc_bdl_ur$uc_bdl_h$BLUE$_user_sym$RESET "
_ps1+="$_gps1_post"

PS1="$_ps1"
PS2='> '
PS4='+ '

new_line_before_prompt=yes

# This function executes before displaying the prompt.
prompt_command () {
	# this must be the first line to capture exit code of last executed
	# command.
	# last command exit code with color
	local _proc_exit=$?
	local _proc_exit_str=''

	if [ "$_proc_exit" -eq 0 ]; then
		_proc_exit_str+="$_user_color[$GREEN$_proc_exit"
	else
		_proc_exit_str+="$_user_color[$RED$_proc_exit"
	fi
	_proc_exit_str+="$_user_color]"

	# add git status prompt
	if [ "$(command -v __git_ps1)" ]; then
		__git_ps1 "$_gps1_pre$_proc_exit_str" "$_gps1_post" \
			"$uc_bdl_h($RESET%s$_user_color)"
	fi

	# Print a new line before the prompt, but only if it is not the first
	# line
	if [ "$new_line_before_prompt" = yes ]; then
		if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
			_NEW_LINE_BEFORE_PROMPT=1
		else
			echo
		fi
	fi

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

	# TODO:
	# * Restrict PS1 output to fixed length.
	# * Use custom git PS1 to fixed length string and colors.

	# set the prompt environment variables
	PS1="${_xterm_title}${PS1}"
}

# `trap` with DEBUG manipulates prompt attributes on output from bash commands
#trap 'tput sgr0' DEBUG

# Bash always executes the contents of this environment variable here it is
# 'prompt_command ()' just before displaying the prompt.
export PROMPT_COMMAND=prompt_command
