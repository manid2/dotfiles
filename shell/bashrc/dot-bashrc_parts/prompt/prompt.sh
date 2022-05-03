# Prompt customization wrapper

# Bash colors
if [ -f ~/.bashrc_parts/common/bash_colors.sh ]; then
    source ~/.bashrc_parts/common/bash_colors.sh
fi

# Control git prompt via sym link instead of global variable for flexibilty.
# TIPS: As we can't remember or see the variable names, it is better to control
# some functions via sym links.
function is_git_prompt_sym_link_exists() {
    local enable_git_ps1=''
    if [ -f ~/.bashrc_part_git_prompt_sym_link.sh ]; then
        enable_git_ps1='yes'
    fi
    echo "$enable_git_ps1"
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
function make_color_prompt_line() {
    local __ps1_line="$(make_color_head_ps1)"

    local __is_git_ps1="$(is_git_prompt_sym_link_exists)"
    if [ "$__is_git_ps1" = 'yes' ]; then
        __ps1_line+="$(make_color_body_ps1_git)"
    fi

    __ps1_line+="$(make_color_tail_ps1)"
    PS1="$__ps1_line"
}

# make colorless prompt line
function make_colorless_prompt_line() {
    local __head_ps1="${debian_chroot:+($debian_chroot)}[\u@\h "
    local __body_ps1='\W]'
    local __tail_ps1='$ '
    local __ps1_line="$__head_ps1$__body_ps1"

    local __is_git_ps1="$(is_git_prompt_sym_link_exists)"
    if [ "$__is_git_ps1" = 'yes' ]; then
        __ps1_line+="$(__git_ps1 " (%s)")"
    fi

    __ps1_line+="$__tail_ps1"
    PS1=$__ps1_line
}

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set the terminal title
function set_terminal_title() {
    local __xterm_title=''
    # Check if this is an xterm
    case "$TERM" in
    xterm* | rxvt*)
        __xterm_title='\[\e]0;\u@\h:\w\a\]'
        ;;
    *)
        __xterm_title=''
        ;;
    esac
    PS1=${__xterm_title}${PS1}
}

# Check if terminal supports color prompt
case "$TERM" in
xterm-color | *-256color)
    color_prompt=yes
    ;;
esac

# make prompt wrapper
function make_prompt_line() {
    if [ "$color_prompt" = yes ]; then
        make_color_prompt_line
    else
        make_colorless_prompt_line
    fi
}

# wrapper function
function prompt_command() {
    make_prompt_line
    set_terminal_title
}

# `trap` with DEBUG manipulates prompt attributes on output from bash commands
trap 'tput sgr0' DEBUG

# PROMPT_COMMAND colors the prompt text and bash commands
export PROMPT_COMMAND=prompt_command

# Bash prompt cusomtization for git
# NOTE: source the git prompt script only once to optimize prompt command
# performance. But it forces the user to re-login or re-source ~/.bashrc
# for the new changes to take effect.
if [ -f ~/.local/bin/git-sh-prompt ]; then
    # git ps1 options
    GIT_PS1_SHOWDIRTYSTATE='y'
    GIT_PS1_SHOWCOLORHINTS='y'
    GIT_PS1_SHOWSTASHSTATE='y'
    GIT_PS1_SHOWUNTRACKEDFILES='y'
    GIT_PS1_DESCRIBE_STYLE='contains'
    GIT_PS1_SHOWUPSTREAM='auto'

    # source sym link to git prompt script
    source ~/.local/bin/git-sh-prompt
fi
