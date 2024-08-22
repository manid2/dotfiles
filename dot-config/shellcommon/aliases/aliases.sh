# Shell common aliases

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	if [ -r ~/.dircolors ]; then
		eval "$(dircolors -b ~/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi

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

# TODO: find aliases
#
# Exclude directories
# find cpp -type d -not -path 'cpp/build*'
# find cpp -type d -not -path 'cpp/build*' -not -path 'cpp'
#
# fd . -t d 'cpp/'
#
# exclude paths using -not operator
# exclude directories.
# find . -name "*docs*" -not -path '*.git/*'
# 
# # exclude files without extensions.
# find . -not -name "*.**" -not -path '*.git/*' -type f
# 
# # exclude paths using -prune option.
# # excludes both *.git* dir & files [-name '*.git*' -prune]
# find . -name '*.git*' -prune -o -name '*docs*'
# 
# # excludes *.git* dir [-type d -name '*.git*' -prune]
# find . -type d -name '*.git*' -prune -o -name '*docs*'
# 
# # excludes *.git* files [-type f -name '*.git*' -prune]
# find . -type f -name '*.git*' -prune -o -name '*docs*'
# 
# # find files and exec command per file (slow)
# find . -exec ls -l {} +
# 
# # find files and exec command for all files (fast)
# find . | xargs -I{} ls -l {}
# 
# find . -type d -empty -delete
# 
# find . -type f -perm /+x
# 
# # find using -regex option
# # use regex file patterns with exclude and include paths
# # unescaped regex string '.*\/.*\.([ch]pp|c|cc|h|hh|py|pyx)$'
# find . -path "./<exclude-dir>/*" -prune -o -path "./<include-dir>/*" \
#   -regex '.*/.*\.\([ch]pp\|c\|cc\|h\|hh\|py\|pyx\)$' -type f -print
# 
# # find all files in project for use with ctags and cscope.
# find $PROJ_SRC_DIRS \( \
# -iname '*.[chyl]' \
# -o -iname '*.pyx' \
# -o -iname '*.py' \
# -o -iname '*.[ch]pp' \
# -o -iname '*.semla' \
# \) \
# -not \( \
# -iname "moc_*.h" \
# -o -iname "moc_*.cpp" \
# -o -iname "ui_*.h" \
# -o -path "*.tox*" \
# -o -path "*pl2py3v*" \
# -o -path "*plapi*.c" \
# -o -path "*include/pl_configvalues*.h" \
#   -o -path "*include/pl_sysdiagdefs.h" \
#   -o -path "*include/pl_sysdiagenums.h" \
#   -o -path "*build/*" \
# \) \
# -a -type f -printf "%P\n" >$PROJ_SRC_FILE_LIST
