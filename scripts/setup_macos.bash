#!/usr/bin/env bash

brew_prefix="$(brew --prefix)"

# TODO use soft links to ~/.local instead of aliases
alias python3="$brew_prefix/bin/python3.10"
alias pip3="$brew_prefix/bin/pip3.10"

alias install="$brew_prefix/bin/ginstall"
alias find="$brew_prefix/bin/gfind"
alias realpath="$brew_prefix/bin/grealpath"
