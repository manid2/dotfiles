#!/bin/bash
#
# Setup system configurations must be run as root

if [ $(id -u) -ne 0 ]; then
	echo "Must be run as root user to install packages"
	exit 1
fi

install_bin () {
	install -v -p -m 755 -D -t /usr/local/bin/ "$1"
}

install_bin configs/xfce/usr/local/bin/tmxr

if [ "$XDG_CURRENT_DESKTOP" = "xfce" ]; then
	install_bin configs/xfce/usr/local/bin/xtm
fi
