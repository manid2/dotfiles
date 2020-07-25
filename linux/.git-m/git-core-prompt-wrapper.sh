# code borrowed from blog on Digital Fortress
# https://digitalfortress.tech/tutorial/setting-up-git-prompt-step-by-step/
# Parts of code is modified

# ANSI color codes
# prompt coilors
MAGENTA='\[\033[00;35m\]'
LIGHT_MAGENTA='\[\033[00;95m\]'
BLUE='\[\033[00;34m\]'
LIGHT_GRAY='\[\033[00;37m\]'
GREEN='\[\033[00;32m\]'
VIOLET='\[\033[00;35m\]'
WHITE='\[\033[00;97m\]'

# git prompt colors
RED='\[\033[00;31m\]'
LIGHT_RED='\[\033[00;91m\]'
YELLOW='\[\033[00;33m\]'
CYAN='\[\033[00;36m\]'

# reset colors
RESET='\[\033[00m\]'

function color_my_prompt() {
    local __user_and_host="$GREEN\u@\h"
    local __cur_location="$BLUE\W" # W: cwd, w: full path to cwd
    local __git_branch_color="$GREEN"
    local __prompt_tail="$VIOLET$"
    local __user_input_color="$LIGHT_MAGENTA"
    local __git_branch=$(__git_ps1)
    local __ps1_color_reset="$RESET"

    # colour branch name depending on state
    if [[ "${__git_branch}" =~ "*" ]]; then # if repository is dirty
        __git_branch_color="$RED"
    elif [[ "${__git_branch}" =~ "%" ]]; then # if there are only untracked files
        __git_branch_color="$LIGHT_RED"       #"$LIGHT_GRAY"
    elif [[ "${__git_branch}" =~ "$" ]]; then # if there is something stashed
        __git_branch_color="$YELLOW"
    elif [[ "${__git_branch}" =~ "+" ]]; then # if there are staged files
        __git_branch_color="$CYAN"
    fi

    # Build the PS1 (Prompt String)
    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+="$__user_and_host:$__cur_location"
    PS1+="$__git_branch_color$__git_branch"
    PS1+="$__prompt_tail"
    PS1+="$__ps1_color_reset"
    PS1+="$__user_input_color "

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;

    esac
}

# use trap with DEBUG to color the output from bash commands
trap 'tput sgr0' DEBUG

# use PROMPT_COMMAND color the prompt text and bash commands
export PROMPT_COMMAND=color_my_prompt

# bash prompt cusomtization for git
if [ -f /etc/bash_completion.d/git-prompt ]; then
    # git ps1 options
    GIT_PS1_SHOWDIRTYSTATE='y'
    GIT_PS1_SHOWCOLORHINTS='y'
    GIT_PS1_SHOWSTASHSTATE='y'
    GIT_PS1_SHOWUNTRACKEDFILES='y'
    GIT_PS1_DESCRIBE_STYLE='contains'
    GIT_PS1_SHOWUPSTREAM='auto'

    # source git prompt script
    source /etc/bash_completion.d/git-prompt
fi
