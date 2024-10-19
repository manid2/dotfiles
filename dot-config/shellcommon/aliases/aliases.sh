# Shell common aliases

_set_colors=yes

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	if [ -r ~/.dircolors ]; then
		eval "$(dircolors -b ~/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi
elif [ -n "$CLICOLOR" ]; then
	# macos: set LSCOLORS
	LSCOLORS='exfxcxdxcxegedabagacadah'	
	export LSCOLORS
else
	_set_colors=no
fi

if [ "$_set_colors" = 'yes' ]; then
	# `less` terminal capabilities
	export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
	export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
	export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
	export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
	export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
	export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
	export LESS_TERMCAP_ue=$'\E[0m'     # reset underline

	alias ls='ls --color=auto'
	alias ip='ip --color=auto'
	alias diff='diff --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
	alias zgrep='zgrep --color=auto'
fi
unset _set_colors

# More `ls` aliases
alias lla='ls -alF'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Diff aliases
alias diff-u3='diff -u3' # unified format with 3 context lines
alias diff-wBu3='diff -wBu3' # ignore blank lines, space changes

# Alias to Xclip select clipboard as it is most used
alias xclip-sc='xclip -sel clip'
# Alias to trim trailing newline when piped to xclip
alias xclip-sc-no-lf='xargs echo -n | xclip-sc'

# add alias/func to `cp --no-preserve=mode/owner/links/time'
alias cp-nm='cp --no-preserve=mode' # cp no mode

# date aliases
alias dtz='date +"%Y-%m-%dT%H:%M:%S%z"'
alias dtymd='date +"%Y-%m-%d"'
alias dtdmy='date +"%d-%m-%Y"'
alias dttm='date +"%H-%M-%S"'
alias dtts='date +"%Y-%m-%d-%H-%M-%S"'
alias dtts2='date +"%Y%m%d%H%M%S"'
alias dtts3='date +"%Y%m%d%H%M%S%N"'

# tmux aliases
alias tmux='tmux -u'
alias tml='tmux ls'
alias tma='tmux a'
alias tmns='tmux new -s'
alias tmks='tmux kill-session -t'
alias tmat='tmux a -t'

# nvim aliases
alias nv='nvim'
alias nvdiff='nvim -d'
alias nvr='nvim -R'
alias nvrm='nvim -RM'

# TODO: add hexdump aliases
# TODO: add tar aliases
# TODO: add find aliases
