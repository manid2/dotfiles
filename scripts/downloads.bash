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

# rvm - ruby version manager
RVM_URL=https://get.rvm.io

if [ ! -d "$RVM_DIR" ]; then
	mkdir -pv "$RVM_DIR"
	# install nvm
	curl -sSfL $RVM_URL | \
	bash -s stable --ruby --ignore-dotfiles --path "$RVM_DIR"
	# use rvm to install ruby & gem
	if [ -s "$RVM_DIR/scripts/rvm" ]; then
		source "$RVM_DIR/scripts/rvm"
		rvm use ruby --default --latest
	fi
fi

# install rust
RUST_URL=https://sh.rustup.rs

if [ ! -d "$RUST_DIR" ]; then
	curl -sSfL $RUST_URL | \
	RUST_HOME="$RUST_HOME" CARGO_HOME="$CARGO_HOME" bash -s -- -y
fi

# install conda
CONDA_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
CONDA_SH="$CONDA_DIR/miniforge.sh"

if [ ! -d "$CONDA_DIR" ]; then
	curl -sSfL "$CONDA_URL" -o "$CONDA_SH" --create-dirs
	bash "$CONDA_SH" -b -p "$CONDA_DIR"
fi

# tpm - tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
