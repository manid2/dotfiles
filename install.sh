#!/bin/bash
#
# Installs dotfiles if not already installed.

# TODO: Add help, command line options and handle optional packages.

# get the sorted list of packages
# find . -maxdepth 1 -not -name '.git' -not -name '.' -type d -printf '%f\n' |
# sort | xclip -sel clip

install_pkgs_to_home () {
	local pkgs_to_home=( \
		gitconfig \
		lynxrc \
		tmux.conf \
		vimrc \
		ripgreprc \
		coloritrc \
	)

	if [[ $SHELL == "/usr/bin/zsh" ]]; then
		pkgs_to_home+=(zshrc)
	else
		pkgs_to_home+=(bashrc)
	fi

	for pkg in "${pkgs_to_home[@]}"
	do
		if [ ! -f ~/.$pkg ]; then
			rel_path=$(realpath --relative-to=$HOME $pkg/dot-$pkg)
			ln -s $rel_path ~/.$pkg
		else
			echo "'$pkg' already installed."
		fi
	done
}

install_pkgs_to_config () {
	local pkgs_to_config=( \
		shellcommon/dot-config/shellcommon \
		mutt/dot-config/mutt \
		nvim/dot-config/nvim \
	)

	if [[ $SHELL == "/usr/bin/zsh" ]]; then
		pkgs_to_config+=(zshrc/dot-config/zshrcparts)
	else
		pkgs_to_config+=(bashrc/dot-config/bashrcparts)
	fi

	# TODO: Use $XDG_CONFIG_HOME with $HOME/.config as fallback.
	CONFIG_HOME="$HOME/.config"
	for pkg in "${pkgs_to_config[@]}"
	do
		pkg_base=$(basename $pkg)
		pkg_dest="$CONFIG_HOME/$pkg_base"
		if [ ! -d $pkg_dest ]; then
			rel_path=$(realpath --relative-to=$CONFIG_HOME $pkg)
			ln -s $rel_path $pkg_dest
		else
			echo "'$pkg' already installed."
		fi
	done
}

install_sshconfig () {
	pkg_ssh_config='ssh/dot-ssh/config'
	home_ssh_config="$HOME/.ssh/config"
	if [ ! -f $home_ssh_config ]; then
		rel_path=$(realpath --relative-to=$HOME/.ssh $pkg_ssh_config)
		ln -s $rel_path $home_ssh_config
	else
		echo "'$pkg_ssh_config' already installed."
	fi
}

install_pkgs_to_home
install_pkgs_to_config
install_sshconfig
