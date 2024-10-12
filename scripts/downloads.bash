#!/usr/bin/env bash

# vim-plug - vim plugin manager
VIM_PLUG="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
VIM_PLUG_VERSION=0.13.0
VIM_PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/${VIM_PLUG_VERSION}/plug.vim

if [ ! -f "$VIM_PLUG" ]; then
	curl -fLo "$VIM_PLUG" --create-dirs "$VIM_PLUG_URL"
fi

# nvm - node version manager
NODE_VERSION=20.12.2
NVM_DIR=~/Downloads/softwares/nvm
NVM_VERSION=0.39.7
NVM_URL=https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh
PROFILE=/dev/null

if [ ! -d "$NVM_DIR" ]; then
	mkdir -pv "$NVM_DIR"
	# install nvm
	curl -o- $NVM_URL | PROFILE="$PROFILE" NVM_DIR="$NVM_DIR" bash
	# use nvm to install node & npm
	if [ -s "$NVM_DIR/nvm.sh" ]; then
		source "$NVM_DIR/nvm.sh"
		nvm install ${NODE_VERSION}
		nvm use v${NODE_VERSION}
		nvm alias default v${NODE_VERSION}
	fi
fi

# tpm - tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# python packages
pipx install grip # github readme instant preview

# install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
