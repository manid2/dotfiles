#!/usr/bin/env bash

source dot-config/shellcommon/common/common.sh

# install python packages
if [ "$(command -v pipx)" ]; then
	pipx_packages=(
		gita
		grip
		weasyprint
	)
	pipx install "${pipx_packages[@]}"
fi

# install rust cargo packages
if [ "$(command -v cargo)" ]; then
	cargo_packages=(
		bat
		fd
		git-delta
		ripgrep
		sd
		zoxide
	)
	cargo install "${cargo_packages[@]}"
fi

# install ruby gem packages
if [ "$(command -v gem)" ]; then
	gem_packages=(
		github-linguist
	)
	gem install "${gem_packages[@]}"
fi

safe_link () {
	if [ ! -L "$2" ] && [ ! -f "$2" ]; then
		ln -s "$1" "$2"
	fi
}

# install brew packages
install_brew_packages () {
	brew_packages=(
		aria2
		bash
		chafa
		clang-format
		cmake
		coreutils
		curl
		dict
		diffutils
		findutils
		gawk
		gcc
		git
		git-gui
		git-lfs
		gitk
		global
		go
		grep
		hugo
		info
		libsecret
		lynx
		make
		manpages
		manpages-dev
		manpages-posix
		manpages-posix-dev
		neofetch
		pipx
		tig
		tmux
		uget
		universal-ctags
		vim
		w3m
		w3m-img
		wget
		zsh
		zsh-autosuggestions
		zsh-syntax-highlighting
	)
	brew install "${brew_packages[@]}"

	# brew command-not-found handler
	brew tap homebrew/command-not-found

	# use gnu utils in macos
	brew_prefix="$(brew --prefix)"

	gnu_utils=(
		find
		grep
		install
		make
		realpath
	)

	for pkg in "${gnu_utils[@]}"
	do
		safe_link "$brew_prefix/bin/g$pkg" "/usr/local/bin/$pkg"
	done
}

if [ "$(uname -s)" = "Darwin" ]; then
    if [ "$(command -v brew)" ]; then
	    install_brew_packages
    fi
fi
