# shellcheck shell=bash disable=SC1090
# bash prompt file, to be sourced into ~/.bashrc

# ANSI color codes
# prompt colors
MAGENTA='\[\033[00;35m\]'
BLUE='\[\033[00;34m\]'
GREEN='\[\033[00;32m\]'

# git prompt colors
RED='\[\033[00;31m\]'
YELLOW='\[\033[00;33m\]'
CYAN='\[\033[00;36m\]'

# reset colors
RESET='\[\033[00m\]'

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
# shellcheck disable=2034
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
_gps1_str=''
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

# truncate strings to 'n' chars
truncate_str_n () {
    str=$1
    len=$2
    if [ "${#str}" -ge "$len" ]; then
        printf "..%s" "${str: -$((len-2)):$len}"
    else
        printf "%s" "$str"
    fi
}

# initliaze local ps1
_ps1=''

# box start ┌──
_ps1+="$_user_color$uc_bdl_dr$uc_bdl_h$uc_bdl_h"

# add chroot if available
_ps1+="${debian_chroot:+($debian_chroot)$uc_bdl_h}"

# add venv if available
_ps1+="${venv_info:+($venv_info)$uc_bdl_h}"

# (user@host:cwd)
# shellcheck disable=SC2016
_ps1_cwd='$(truncate_str_n ${PWD/#$HOME/"~"} 16)'
_ps1+="($CYAN\u$YELLOW@$CYAN\h$YELLOW:$BLUE$_ps1_cwd$_user_color)$uc_bdl_h"

# [date time] in dd-Mon-yyyy H:M:S in 24 hr format
_ps1+="[$MAGENTA\D{%d-%b-%Y %H:%M:%S}$_user_color]"
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
		# shellcheck disable=1087
		_proc_exit_str+="$_user_color[$GREEN$_proc_exit"
	else
		# shellcheck disable=1087
		_proc_exit_str+="$_user_color[$RED$_proc_exit"
	fi
	_proc_exit_str+="$_user_color]"

	PS1="$_gps1_pre"

	# add git status prompt
	if [ "$(command -v __git_ps1)" ]; then
		_gps1_str="$(__git_ps1 '%s')"
		if [ -n "${_gps1_str// -}" ]; then
			PS1+="$uc_bdl_h("
			PS1+="$(truncate_str_n $"$_gps1_str" 24)"
			PS1+="$_user_color)"
		fi
	fi

	PS1+="$_gps1_post"

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

	# set the prompt environment variables
	PS1="${_xterm_title}${PS1}"
}

# `trap` with DEBUG manipulates prompt attributes on output from bash commands
#trap 'tput sgr0' DEBUG

# Bash always executes the contents of this environment variable here it is
# 'prompt_command ()' just before displaying the prompt.
export PROMPT_COMMAND=prompt_command
