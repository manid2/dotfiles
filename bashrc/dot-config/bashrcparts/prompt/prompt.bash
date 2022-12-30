# Prompt customization wrapper

# Shell common colors
if [ -f ~/.config/shellcommon/common/colors.sh ]; then
	source ~/.config/shellcommon/common/colors.sh
fi

# __head_ps1 = debian_chroot + user + host + cwd
make_color_head_ps1 () {
	local __user_and_host="$GREEN\u@\h"
	local __cur_location="$BLUE\W" # W: cwd, w: full path to cwd

	local __head_ps1="${debian_chroot:+($debian_chroot)}"
	__head_ps1+="$__user_and_host:$__cur_location"
	echo "$__head_ps1"
}

# __tail_ps1 = __prompt_tail
make_color_tail_ps1 () {
	local __prompt_tail="$VIOLET$"
	local __ps1_color_reset="$RESET"

	local __tail_ps1="$__prompt_tail"
	__tail_ps1+="$__ps1_color_reset"
	__tail_ps1+=" "
	echo "$__tail_ps1"
}

# __ps1_line = __head_ps1 + __body_ps1_git + __tail_ps1
make_color_prompt_line () {
	local __ps1_line="$(make_color_head_ps1)"

	__ps1_line+="$RESET$(__git_ps1 ' (%s)')"

	__ps1_line+="$(make_color_tail_ps1)"
	PS1="$__ps1_line"
}

# make colorless prompt line
make_colorless_prompt_line () {
	local __head_ps1="${debian_chroot:+($debian_chroot)}[\u@\h "
	local __body_ps1='\W]'
	local __tail_ps1='$ '
	local __ps1_line="$__head_ps1$__body_ps1"

	__ps1_line+="$(__git_ps1 ' (%s)')"

	__ps1_line+="$__tail_ps1"
	PS1=$__ps1_line
}

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# Set the terminal title
set_terminal_title () {
	local __xterm_title=''
	# Check if this is an xterm
	case "$TERM" in
		xterm* | rxvt*)
			__xterm_title='\[\e]0;\u@\h:\w\a\]'
			;;
		*)
			__xterm_title=''
			;;
	esac
	PS1=${__xterm_title}${PS1}
}

# Check if terminal supports color prompt
case "$TERM" in
	xterm-color | *-256color)
		color_prompt=yes
		;;
esac

# make prompt wrapper
make_prompt_line () {
	if [ "$color_prompt" = yes ]; then
		make_color_prompt_line
	else
		make_colorless_prompt_line
	fi
}

# wrapper function
prompt_command () {
	make_prompt_line
	set_terminal_title
}

# `trap` with DEBUG manipulates prompt attributes on output from bash commands
#trap 'tput sgr0' DEBUG

# PROMPT_COMMAND colors the prompt text and bash commands
export PROMPT_COMMAND=prompt_command

# Shell common prompt configs
if [ -f ~/.config/shellcommon/prompt/prompt.sh ]; then
	source ~/.config/shellcommon/prompt/prompt.sh
fi
