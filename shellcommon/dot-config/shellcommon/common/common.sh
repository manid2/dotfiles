#!/usr/bin/env sh

# Workspace aliases for faster navigation
mwp="$HOME/Documents/myworkspace"

if [[ -z $MYWORKSPACE ]]; then
	mwp=$MYWORKSPACE
fi

alias mwp="cd \"$mwp\""
export mwp
