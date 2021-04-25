# zsh prompt file, to be sourced into ~/.zshrc

# Variable to identify the chroot for display in prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# override default virtualenv indicator in prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
venv_info() {
    [ $VIRTUAL_ENV ] && echo "(%B%F{reset}$(basename $VIRTUAL_ENV)%b%F{%(#.blue.green)})"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # set color prompt
    # PROMPT = {debian_chroot}{venv_info}{user}@{host}{cwd}
    prompt_symbol=@                      # user prompt symbol
    [ "$EUID" -eq 0 ] && prompt_symbol=% # root user prompt symbol
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
    # TBD use custom colors and in precomd() for git ps1 as used in bashrc
    # (git ps1 line)
    # enable only if $DISABLE_GIT_PS1 is not set
    # useful to disable git ps1 on demand and in local to env
    if [ -z "$DISABLE_GIT_PS1" ]; then
        PROMPT+=$'%F{%(#.blue.green)}%F{reset}$(__git_ps1 " (%s)")%F{%(#.blue.green)}'
    fi
    # user command line
    PROMPT+=$'\n%b%F{%(#.blue.green)}└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
    RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'

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
else
    # set colorless prompt
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %1~\a'
    ;;
*) ;;
esac

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

# Set git ps1 options and source git-sh-prompt script if available
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
