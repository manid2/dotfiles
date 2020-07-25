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
export RSYNC_HOME=$HOME/.rsync-m
# TODO: break the long line aliases into 80 column lines
alias rsync-m="rsync -zamvh --no-l --include-from=$RSYNC_HOME/rs-inc.txt --exclude-from=$RSYNC_HOME/rs-exc.txt"
alias rsync-n="rsync -n -zamvh --no-l --include-from=$RSYNC_HOME/rs-inc.txt --exclude-from=$RSYNC_HOME/rs-exc.txt"
alias rsync-lm="rsync -zamvh --no-l -L --include-from=$RSYNC_HOME/rs-inc.txt --exclude-from=$RSYNC_HOME/rs-exc.txt"
alias rsync-ln="rsync -n -zamvh --no-l -L --include-from=$RSYNC_HOME/rs-inc.txt --exclude-from=$RSYNC_HOME/rs-exc.txt"
alias rsync-lmw="rsync -zamvh --no-l -L --exclude=$EXC_PATTERN --include-from=$RSYNC_HOME/rs-inc.txt --exclude-from=$RSYNC_HOME/rs-exc.txt"
alias rsync-lnw="rsync -n -zamvh --no-l -L --exclude=$EXC_PATTERN --include-from=$RSYNC_HOME/rs-inc.txt --exclude-from=$RSYNC_HOME/rs-exc.txt"

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
