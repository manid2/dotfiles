# shellcheck shell=bash disable=all
# zsh prompt file, to be sourced into ~/.zshrc

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# override default virtualenv indicator in prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
venv_info () {
	[ $VIRTUAL_ENV ] && echo "(${VIRTUAL_ENV:+$(basename $VIRTUAL_ENV)})$uc_bdl_h"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

_gps1_pre=''
_gps1_str=''
_gps1_post=''

if [ "$color_prompt" = yes ]; then
	# set color prompt
	# normal user color and symbol
	_user_sym='$'
	_user_color='%F{green}'
	# root user color and symbol
	if [ "$EUID" -eq 0 ]; then
		_user_sym='#'
		_user_color='%F{magenta}'
	fi

	# initialize PROMPT
	PROMPT=''
	# box start ┌──
	PROMPT+=$'$_user_color$uc_bdl_dr$uc_bdl_h$uc_bdl_h'

	# add chroot if available
	PROMPT+=$'${debian_chroot:+($debian_chroot)$uc_bdl_h}'

	# add venv if available
	PROMPT+=$'$(venv_info)'

	# (user@host:cwd)
	PROMPT+=$'(%F{cyan}%n%f%F{yellow}@%f%F{cyan}%m%f%F{yellow}:%f'
	PROMPT+=$'%F{blue}%16<..<%~%<<%f$_user_color)$uc_bdl_h'

	# [date time] in dd-Mon-yyyy H:M:S.ms in 24 hr format
	PROMPT+=$'(%F{magenta}%D{%d-%b-%Y %H:%M:%S.%.}%f$_user_color)$uc_bdl_h'

	# last command exit code with color
	PROMPT+=$'(%(?.%F{green}%?%f.%F{red}%?%f)$_user_color)'

	_gps1_pre+=$PROMPT

	# add user prompt symbol '$' or '#' if root
	_gps1_post+=$'\n$uc_bdl_ur$uc_bdl_h%B%F{blue}$_user_sym%b%F{reset} '
	PROMPT+="$_gps1_post"
else
	# set colorless prompt
	PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm* | rxvt*)
		TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %1~\a'
		;;
	*) ;;
esac

new_line_before_prompt=yes

precmd () {
	# Print the previously configured title
	print -Pnr -- "$TERM_TITLE"

	# Print a new line before the prompt, but only if it is not the first
	# line
	if [ "$new_line_before_prompt" = yes ]; then
		if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
			_NEW_LINE_BEFORE_PROMPT=1
		else
			print ""
		fi
	fi

	PROMPT="$_gps1_pre"

	# add git status prompt
	if [ "$(command -v __git_ps1)" ]; then
		_gps1_str="$(__git_ps1 '%s')"
		_gps1_sha="$(git_short_sha)"
		if [ -n "${_gps1_str// -}" ]; then
			PROMPT+="$uc_bdl_h("
			PROMPT+=$'%24<..<$_gps1_str%<<'
			PROMPT+=" %F{cyan}"
			PROMPT+=$'%8<..<$_gps1_sha%<<'
			PROMPT+="$_user_color)"
		fi
	fi

	PROMPT+="$_gps1_post"
}
