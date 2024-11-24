#!/bin/bash
#
# Install system packages must be run as root

if [ $(id -u) -ne 0 ]; then
	echo "Must be run as root user to install packages"
	exit 1
fi

has_gui () {
	ls /usr/share/xsessions/ 2>/dev/null
}

# install apt packages
install_apt_packages () {
	apt_packages=(
		adduser
		anacron
		apt-file
		aria2
		bash
		build-essential
		chafa
		clang
		clang-format
		clang-tidy
		clang-tools
		clangd
		coreutils
		cpio
		cron
		cron-daemon-common
		curl
		debconf
		debconf-i18n
		debian-archive-keyring
		debianutils
		dict
		diffutils
		dkms
		expect
		findutils
		gcc-doc
		git
		global
		info
		libsecret-tools
		logrotate
		lynx
		manpages
		manpages-dev
		manpages-posix
		manpages-posix-dev
		neofetch
		pipx
		tig
		tmux
		universal-ctags
		vim
		vim-addon-manager
		w3m
		w3m-img
		wget
		xclip
		zsh
		zsh-autosuggestions
		zsh-syntax-highlighting
	)

	apt_gui_packages=(
		cheese
		git-gui
		gitk
		hugo
		shotcut
		uget
		vlc
	)

	gcc_version=$(gcc --version | grep ^gcc | sed 's/^.* //g' | cut -d'.' -f1)
	apt_gcc_libcpp_docs="libstdc++-$gcc_version-doc"

	apt-get update && \
	apt-get install -y "${apt_packages[@]}" "$apt_gcc_libcpp_docs"

	has_gui && apt-get install -y "${apt_gui_packages[@]}"
}

SYS_NAME=$(uname -s)

if [ "$SYS_NAME" = "Linux" ]; then
	if [ "$(command -v apt-get)" = "apt-get" ]; then
		install_apt_packages
	fi
elif [ "$SYS_NAME" = "Darwin" ]; then
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | \
	NONINTERACTIVE=1 bash
fi
