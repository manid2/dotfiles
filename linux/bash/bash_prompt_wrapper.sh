#!/bin/bash
# Prompt customization wrapper

# TODO: add logic to handle non-color prompts
# Check if terminal supports color prompt
#case "$TERM" in
#xterm-color | *-256color)
#    color_prompt=yes
#    ;;
#esac

# Bash colors
if [ -f ~/bash/bash_colors.sh ]; then
    source ~/bash/bash_colors.sh
fi

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set the terminal title
function set_terminal_title() {
    # Check if this is an xterm
    case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;
    esac
}

# __head_ps1 = debian_chroot + user + host + cwd
function make_color_head_ps1() {
    local __user_and_host="$GREEN\u@\h"
    local __cur_location="$BLUE\W" # W: cwd, w: full path to cwd

    local __head_ps1="${debian_chroot:+($debian_chroot)}"
    __head_ps1+="$__user_and_host:$__cur_location"
    echo "$__head_ps1"
}

# __body_ps1_git = __git_branch
function make_color_body_ps1_git() {
    # Git prompt code is borrowed from blog on Digital Fortress
    # https://digitalfortress.tech/tutorial/setting-up-git-prompt-step-by-step/
    # Parts of code is modified
    local __git_branch_color="$GREEN"
    local __git_branch=$(__git_ps1)

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

    local __body_ps1_git="$__git_branch_color$__git_branch"
    echo "$__body_ps1_git"
}

# __tail_ps1 = __prompt_tail
function make_color_tail_ps1() {
    local __prompt_tail="$VIOLET$"
    local __user_input_color="$LIGHT_MAGENTA"
    local __ps1_color_reset="$RESET"

    local __tail_ps1="$__prompt_tail"
    __tail_ps1+="$__ps1_color_reset"
    __tail_ps1+="$__user_input_color"
    __tail_ps1+=" "
    echo "$__tail_ps1"
}

# __ps1_line = __head_ps1 + __body_ps1_git + __tail_ps1
function make_prompt_line() {
    local __ps1_line="$make_color_head_ps1"
    __ps1_line+="$make_color_body_ps1_git"
    __ps1_line+="$make_color_tail_ps1"

    # PS1 controls prompt line
    PS1="$__ps1_line"
}

# `trap` with DEBUG manipulates prompt attributes on output from bash commands
trap 'tput sgr0' DEBUG

# FIXME: PROMPT_COMMAND not working as expected, test in docker image
# PROMPT_COMMAND colors the prompt text and bash commands
export PROMPT_COMMAND=$make_prompt_line$set_terminal_title

# Bash prompt cusomtization for git
if [ -f ~/bash/git_prompt_wrapper.sh ]; then
    # git ps1 options
    GIT_PS1_SHOWDIRTYSTATE='y'
    GIT_PS1_SHOWCOLORHINTS='y'
    GIT_PS1_SHOWSTASHSTATE='y'
    GIT_PS1_SHOWUNTRACKEDFILES='y'
    GIT_PS1_DESCRIBE_STYLE='contains'
    GIT_PS1_SHOWUPSTREAM='auto'

    # source git prompt wrapper script
    source ~/bash/git_prompt_wrapper.sh
fi
