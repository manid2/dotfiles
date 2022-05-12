# zsh configs file, to be sourced into ~/.zshrc

WORDCHARS=${WORDCHARS//\//} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors &&
        eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'     # reset underline
fi

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000

# configure `time` format
TIMEFMT=$'real\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# add user local bin path
path=($HOME/.local/bin $path)
