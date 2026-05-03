# shellcheck disable=all
# source local git-sh-prompt script
if [ -f ~/.local/lib/git-sh-prompt ]; then
    # git ps1 options
    export GIT_PS1_SHOWDIRTYSTATE='y'
    export GIT_PS1_SHOWCOLORHINTS='y'
    export GIT_PS1_SHOWSTASHSTATE='y'
    export GIT_PS1_SHOWUNTRACKEDFILES='y'
    export GIT_PS1_DESCRIBE_STYLE='contains'
    export GIT_PS1_SHOWUPSTREAM='auto'

    # source sym link to git prompt script
    source ~/.local/lib/git-sh-prompt
fi
