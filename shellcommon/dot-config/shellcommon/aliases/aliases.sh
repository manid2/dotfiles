# Shell common aliases

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors &&
        eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=always'
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
alias dt='date'
alias dty='date +"%Y"'
alias dtm='date +"%m"'
alias dtd='date +"%d"'
alias dtymd='date +"%Y-%m-%d"'
alias dtdmy='date +"%d-%m-%Y"'
alias dtftm='date +"%H:%M:%S:%N"'
alias dtr='date -R'
alias dtu='date -u'
alias dtdnw='date -d "now"'

# tmux aliases
alias tmux='tmux -u'
alias tml='tmux ls'
alias tma='tmux a'
alias tmns='tmux new -s'
alias tmks='tmux kill-session -t'
alias tmat='tmux a -t'

# TODO: add hexdump aliases
# TODO: add tar aliases
# TODO: add find aliases
