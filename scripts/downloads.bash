#!/usr/bin/env bash

source dot-config/shellcommon/common/common.sh

# vim-plug - vim plugin manager
VIM_PLUG="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
VIM_PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ ! -f "$VIM_PLUG" ]; then
	curl -sSfL "$VIM_PLUG_URL" -o "$VIM_PLUG" --create-dirs
fi

# nvm - node version manager
NVM_URL=https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh
PROFILE=/dev/null

if [ ! -d "$NVM_DIR" ]; then
	mkdir -pv "$NVM_DIR"
	# install nvm
	curl -sSfL $NVM_URL | PROFILE="$PROFILE" NVM_DIR="$NVM_DIR" bash
	# use nvm to install node & npm
	if [ -s "$NVM_DIR/nvm.sh" ]; then
		source "$NVM_DIR/nvm.sh"
		nvm install --lts
		nvm use --lts
		nvm alias default node
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
