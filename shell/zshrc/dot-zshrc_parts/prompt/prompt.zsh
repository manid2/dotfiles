# zsh prompt file, to be sourced into ~/.zshrc

# TODO Use zsh specific commands here
# TODO re-design shell prompt for zsh

# Source prompt colors
if [ -f ~/.zshrc_parts/common/colors.zsh ]; then
    . ~/.zshrc_parts/common/colors.zsh
fi

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# override default virtualenv indicator in prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
venv_info() {
    [ $VIRTUAL_ENV ] && echo "(%B%F{reset}$(basename $VIRTUAL_ENV)%b%F{%(#.blue.green)})"
}

# TODO: use red color if root user
# TODO follow zsh spec.
# __sys_ps1_part = debian_chroot + venv_info + user + host + cwd
function make_color_sys_ps1() {
    # TODO: make color prompt line
    # ┌──([{debian_chroot}][{venv_info}] {user}@{host})──[{cwd}]
    prompt_symbol=㉿
    [ "$EUID" -eq 0 ] && prompt_symbol=💀

    # Error occurred when sourcing this file multiple times in same terminal.
    # This error is recurring.
    # Err: _zsh_autosuggest_bound_5_accept-line:2: maximum nested function level reached; increase FUNCNEST?
    # {debian_chroot}{venv_info}
    PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)──}$(venv_info)'
    # (user@host)
    PROMPT+=$'(%B%F{%(#.red.blue)}%n$prompt_symbol%m%b%F{%(#.blue.green)})'
    # [cwd]
    PROMPT+=$'-[%F{%(#.magenta.cyan)}%1~%F{%(#.blue.green)}]'
    # [date time] in %W dd/mm/yy and %* H:M:S in 24 hr format
    PROMPT+=$'-[%F{%(#.cyan.magenta)}%W %*%F{%(#.blue.green)}]'
    # [last command exit success/error symbol and code]
    PROMPT+=$'-[%(?.%F{green}√%?%f.%F{red}?%?%f)%F{%(#.blue.green)}]'
    # (git ps1 line)
    PROMPT+=$'%F{%(#.blue.green)}%F{reset}$(__git_ps1 " (%s)")%F{%(#.blue.green)}'
    # user command line
    PROMPT+=$'\n%b%F{%(#.blue.green)}└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
    RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
}

# TODO follow zsh spec.
# __git_ps1_part = "( on {git_ps1})""
function make_color_git_ps1() {
    # TODO: make color {git_prompt}, check if zsh has plugin for this
    # if zsh plugin has no external dependecy and easy to customize then use.
    # Git prompt code is borrowed from blog on Digital Fortress
    # https://digitalfortress.tech/tutorial/setting-up-git-prompt-step-by-step/
    # Parts of code is modified
    local __git_ps1_part_color="$GREEN"
    # get git branch info from `__git_ps1` in `git-sh-prompt` script
    # git-sh-prompt script is available in debian git package
    local __git_ps1_part_info=$(__git_ps1)

    # colour branch name depending on state
    if [[ "${__git_ps1_part_info}" =~ "*" ]]; then # if repository is dirty
        __git_ps1_part_color="$RED"
    elif [[ "${__git_ps1_part_info}" =~ "%" ]]; then # if there are only untracked files
        __git_ps1_part_color="$LIGHT_RED"            #"$LIGHT_GRAY"
    elif [[ "${__git_ps1_part_info}" =~ "$" ]]; then # if there is something stashed
        __git_ps1_part_color="$YELLOW"
    elif [[ "${__git_ps1_part_info}" =~ "+" ]]; then # if there are staged files
        __git_ps1_part_color="$CYAN"
    fi

    local __git_ps1_part="$__git_ps1_part_color$__git_ps1_part_info"
    echo "$__git_ps1_part"
}

# As some git repos are too large and cause performance issue when using the
# shell, so enable/disable as needed and also local to a shell session.
function is_git_ps1_enabled() {
    # TODO: Control git prompt via environment variable
}

# TODO follow zsh spec.
# __ps1_line = __sys_ps1_part + __git_ps1_part
function make_color_prompt_line() {
    local __ps1_line="$(make_color_sys_ps1)"

    local __is_git_ps1="$(is_git_ps1_enabled)"
    if [ "$__is_git_ps1" = 'yes' ]; then
        __ps1_line+="$(make_color_git_ps1)"
    fi

    # TODO: use zsh PROMPT instead of PS1
    PS1="$__ps1_line"
}

# TODO follow zsh spec.
# make colorless prompt line
function make_colorless_prompt_line() {
    local __sys_ps1_part="${debian_chroot:+($debian_chroot)}"
    __sys_ps1_part +="$(venv_info)\u@\h:"
    local __body_ps1='\W'
    local __tail_ps1='$ '
    local __ps1_line="$__sys_ps1_part$__body_ps1"

    local __is_git_ps1="$(is_git_ps1_enabled)"
    if [ "$__is_git_ps1" = 'yes' ]; then
        __ps1_line+="$(__git_ps1 " (%s)")"
    fi

    # TODO: use zsh PROMPT instead of PS1
    __ps1_line+="$__tail_ps1"
    PS1=$__ps1_line
}

# Set the terminal title
function set_terminal_title() {
    local __xterm_title=''
    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm* | rxvt*)
        __xterm_title=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
        ;;
    *)
        __xterm_title=''
        ;;
    esac
    # TODO: check if this is compatible with zsh
    TERM_TITLE=${__xterm_title}
}

new_line_before_prompt=yes
precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$new_line_before_prompt" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# Check if terminal supports color prompt
case "$TERM" in
xterm-color | *-256color)
    color_prompt=yes
    ;;
esac

# TODO: check if this is required
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
#
#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#        # We have color support; assume it's compliant with Ecma-48
#        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#        # a case would tend to support setf rather than setaf.)
#        color_prompt=yes
#    else
#        color_prompt=
#    fi
#fi

# enable syntax highlighting via zsh plugin
if [ "$color_prompt" = yes ]; then
    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown - token]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[reserved - word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix - alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global - alias]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=underline
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history - expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command - substitution]=none
        ZSH_HIGHLIGHT_STYLES[command - substitution - delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[process - substitution]=none
        ZSH_HIGHLIGHT_STYLES[process - substitution - delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[single - hyphen - option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[double - hyphen - option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back - quoted - argument]=none
        ZSH_HIGHLIGHT_STYLES[back - quoted - argument - delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single - quoted - argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double - quoted - argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar - quoted - argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc - quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar - double - quoted - argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back - double - quoted - argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back - dollar - quoted - argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named - fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric - fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
        ZSH_HIGHLIGHT_STYLES[bracket - error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket - level - 1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket - level - 2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket - level - 3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket - level - 4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket - level - 5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor - matchingbracket]=standout
    fi
fi

# Use color prompt if colors terminal supports color else use colorless prompt
function make_prompt_line() {
    if [ "$color_prompt" = yes ]; then
        make_color_prompt_line
    else
        make_colorless_prompt_line
    fi
}

unset color_prompt # force_color_prompt

# TODO: check if this applies to ZSH and QTerminal too
# set prompt line and terminal title
function prompt_command() {
    make_prompt_line
    set_terminal_title
}

# TODO follor zsh spec
# PROMPT_COMMAND colors the prompt text and bash commands
export PROMPT_COMMAND=prompt_command

# Set git ps1 options and source git-sh-prompt script
# TODO: control git ps1 via `GIT_PS1_ENABLED` env var
if [ -f /usr/lib/git-core/git-sh-prompt ]; then
    # git ps1 options
    GIT_PS1_SHOWDIRTYSTATE='y'
    GIT_PS1_SHOWCOLORHINTS='y'
    GIT_PS1_SHOWSTASHSTATE='y'
    GIT_PS1_SHOWUNTRACKEDFILES='y'
    GIT_PS1_DESCRIBE_STYLE='contains'
    GIT_PS1_SHOWUPSTREAM='auto verbose'

    # source sym link to git prompt script
    . /usr/lib/git-core/git-sh-prompt
fi
