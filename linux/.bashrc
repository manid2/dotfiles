#!/bin/bash
#
# Root bashrc, contains sym links to logically grouped settings
# NOTE: use docker image to test the scripts

# Do nothing in non-interactive session as invoked by scp using sshd
case $- in
*i*) ;;
*) return ;;
esac

# Control bash history
HISTCONTROL=ignoreboth # ignore duplicatess and commands with lead space
HISTSIZE=1000          # no. of cmds stored in memory in present bash session
HISTFILESIZE=2000      # no. of cmds at startup + no. of cmds at session end
shopt -s histappend    # append to previous history

# Check window size after each command, if necessary, updates LINES & COLUMNS
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Bash aliases wrapper
if [ -f ~/bash/bash_aliases_wrapper.sh ]; then
    source ~/bash/bash_aliases_wrapper.sh
fi

# Bash prompt customization wrapper
if [ -f ~/bash/bash_prompt_wrapper.sh ]; then
    source ~/bash/bash_prompt_wrapper.sh
fi

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi

# TODO: move app/system specific to separate scripts
# Ruby gems installed to $HOME/gems, used only for ruby gems installation
#export GEM_HOME="$HOME/gems"
#export PATH="$GEM_HOME/bin:$PATH"
