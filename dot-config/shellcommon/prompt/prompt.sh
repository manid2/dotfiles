# shellcheck disable=all
# source local git-sh-prompt script
if [ -f ~/.local/lib/git-sh-prompt ]; then
    # git ps1 options
    GIT_PS1_SHOWDIRTYSTATE='y'
    GIT_PS1_SHOWCOLORHINTS='y'
    GIT_PS1_SHOWSTASHSTATE='y'
    GIT_PS1_SHOWUNTRACKEDFILES='y'
    GIT_PS1_DESCRIBE_STYLE='contains'
    GIT_PS1_SHOWUPSTREAM='auto'

    # source sym link to git prompt script
    source ~/.local/lib/git-sh-prompt
fi
