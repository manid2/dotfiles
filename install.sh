#!/usr/bin/env sh
#
# Installs dotfiles if not already installed.

# get the sorted list of packages
# find . -maxdepth 1 -not -name '.git' -not -name '.' -type d -printf '%f\n' |
# sort | xclip -sel clip

install_pkgs_to_home () {
	pkgs_to_home=(\
		bashrc \
		gitconfig \
		lynxrc \
		tmux.conf \
		vimrc \
		zshrc \
	)

	for pkg in "${pkgs_to_home[@]}"
	do
		if [[ ! -f ~/.$pkg ]]; then
			ln -s `realpath --relative-to=$HOME $pkg/dot-$pkg` \
				~/.$pkg
		fi
	done
}

install_pkgs_to_config () {
	pkgs_to_config=(\
		bashrc/dot-config/bashrcparts \
		zshrc/dot-config/zashrcparts \
		shellcommon/dot-config/shellcommon
	)

	for pkg in "${pkgs_to_home[@]}"
	do
		if [[ ! -f ~/.$pkg ]]; then
			ln -s `realpath --relative-to=$HOME/.config $pkg` \
				~/.config/`basename $pkg`
		fi
	done
}

install_ssh () {
	if [[ ! -f ~/.ssh/config ]]; then
		ln -s `realpath --relative-to=$HOME/.ssh ssh/dot-ssh/config` \
			~/.ssh/config
	fi
}
