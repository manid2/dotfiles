#!/bin/bash
#
# Install system packages must be run as root

if [ $(id -u) -ne 0 ]; then
	echo "Must be run as root user to install packages"
	exit 1
fi

sys_admin_pkgs=(
	adduser
	anacron
	apt-file
	bash
	checksecurity
	coreutils
	cpio
	cron
	cron-daemon-common
	debconf
	debconf-i18n
	debian-archive-keyring
	debianutils
	dkms
	logrotate
	zsh
	zsh-autosuggestions
	zsh-syntax-highlighting
)

code_pkgs=(
	build-essential
	clang
	clang-format
	clang-tidy
	clang-tools
	clangd
	cscope
	expect
	git
	git-delta
	git-gui
	gita
	gitk
	global
	global
	hugo
	info
	tig
	tmux
	universal-ctags
	vim
	vim-addon-manager
)

utils_pkgs=(
	bat
	cscope
	curl
	dict
	diffutils
	fd-find
	findutils
	libsecret-tools
	lynx
	neofetch
	pipx
	python3-pip
	ripgrep
	w3m
	w3m-img
	wget
	xclip
)

multimedia_pkgs=(
	chafa
	cheese
	shotcut
	vlc
)

apt-get update && \
apt-get install -y \
  "${sys_admin_pkgs[@]}" \
  "${code_pkgs[@]}" \
  "${utils_pkgs[@]}" \
  "${multimedia_pkgs[@]}"
