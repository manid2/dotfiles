# zsh prompt file, to be sourced into ~/.zshrc

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
	PROMPT+=$'${venv_info:+($venv_info)$uc_bdl_h}'

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
	PROMPT+='$_gps1_post'

	RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'

	# enable syntax-highlighting
	if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
		source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
		ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
		ZSH_HIGHLIGHT_STYLES[default]=none
		ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
		ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
		ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[path]=underline
		ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
		ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
		ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[command-substitution]=none
		ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[process-substitution]=none
		ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
		ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[assign]=none
		ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
		ZSH_HIGHLIGHT_STYLES[named-fd]=none
		ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
		ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
		ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
		ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
	fi
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

	# TODO:
	# * Restrict PS1 output to fixed length.
	# * Use custom git PS1 to fixed length string and colors.

	# add git status prompt
	if [ "$(command -v __git_ps1)" ]; then
		__git_ps1 "$_gps1_pre" "$_gps1_post" \
			"$uc_bdl_h(%%F{reset}%s%%f%$_user_color)"
	fi
}
