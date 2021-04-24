# zsh aliases file, to be sourced into ~/.zshrc

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors &&
        eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

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

# Alias to Xclip select clipboard as it is most used
alias xclip-sc='xclip -sel clip'
# Alias to trim trailing newline when piped to xclip
alias xclip-sc-no-lf='xargs echo -n | xclip-sc'

# force zsh to show the complete history
alias history="history 0"
# Alias to print history without cmd num
alias history-no-num="history | sed 's/^[[:space:]]*[[:digit:]]*[[:space:]]*//g'"

# Workspace aliases for faster navigation
export mwp="$HOME/Documents/myworkspace"
alias mwp="cd \"$mwp\""
