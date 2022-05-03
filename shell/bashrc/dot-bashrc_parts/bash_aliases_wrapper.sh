# Bash aliases wrapper

# Enable color support of ls and greps
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors &&
        eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias diff='diff --color'

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

# Rsync aliases
export RSYNC_HOME=$HOME/.rsync_data

alias rsync-m="rsync -zamvh --no-l \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-n="rsync -n -zamvh --no-l \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-lm="rsync -zamvh --no-l -L \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-ln="rsync -n -zamvh --no-l -L \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-lmw="rsync -zamvh --no-l -L \
--exclude=$EXCLUDE_PATTERN \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-lnw="rsync -n -zamvh --no-l -L \
--exclude=$EXCLUDE_PATTERN \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

# Diff aliases
# Ignore space changes and blank lines, use unified format with 3 context lines
alias diff-wBu3='diff -wBu3'

# Workspace aliases for faster navigation
export ECLIPSE_WORKSPACE_PATH="$HOME/Documents/eclipse-workspace"
export ewp=$ECLIPSE_WORKSPACE_PATH
alias ewp="cd \"$ewp\""

# Alias to Xclip select clipboard as it is most used
alias xclip-sc='xclip -sel clip'
# Alias to trim trailing newline when piped to xclip
alias xclip-sc-no-lf='xargs echo -n | xclip-sc'

# Alias to print history without cmd num
alias history-no-num="history | sed 's/^[[:space:]]*[[:digit:]]*[[:space:]]*//g'"

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
