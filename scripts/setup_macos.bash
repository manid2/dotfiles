#!/usr/bin/env bash

# install GNU utilities & others
brew install coreutils findutils gcc make neofetch delta fd sd bat git git-gui tig

# brew command-not-found handler
brew tap homebrew/command-not-found

brew_prefix="$(brew --prefix)"

safe_link () {
	if [ ! -L "$2" ] && [ ! -f "$2" ]; then
		ln -s "$1" "$2"
	fi
}

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

safe_link "$brew_prefix/bin/python3.10" ~/.local/bin/python3
safe_link "$brew_prefix/bin/pip3.10" ~/.local/bin/pip3
