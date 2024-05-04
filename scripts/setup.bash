#!/bin/bash

source dot-config/shellcommon/plugins/lnr/lnr.plugin.sh

if [ ! -f ~/.local/share/nvim/plugged/vim-plug-setup-done ]; then
	vim '+PlugInstall' '+qa'
	touch ~/.local/share/nvim/plugged/vim-plug-setup-done
fi

if [ ! -f ~/.tmux/plugins/tpm-setup-done ]; then
	~/.tmux/plugins/tpm/bin/install_plugins
	touch ~/.tmux/plugins/tpm-setup-done
fi

mkdir -pv ~/.local/{bin,lib,share}
mkdir -pv ~/.local/share/zsh/user-{completions,functions}

install_bin () {
	install -v -p -m 755 -D -t ~/.local/bin/ "$1"
}

install_config () {
	install -v -p -m 644 "$1" -D -t "$2"
}

safe_link () {
	if [ ! -L "$2" ] && [ ! -f "$2" ]; then
		ln -s "$1" "$2"
	fi
}

install_bin /usr/share/doc/git/contrib/git-jump/git-jump

install_config dot-local/app.d/xfce/local/share/xfce4/helpers/xtm.desktop \
~/.local/share/xfce4/helpers/

install_config dot-local/app.d/xfce/config/autostart/Terminal.desktop \
~/.config/autostart/

safe_link /usr/lib/git-core/git-sh-prompt ~/.local/lib/git-sh-prompt
safe_link /usr/bin/fdfind ~/.local/bin/fd
safe_link /usr/bin/batcat ~/.local/bin/bat

lnr_bin -s ~/.vim/plugged/fzf/bin/fzf || true

lnr_target -s ~/.vim/plugged/fzf/shell/key-bindings.zsh \
~/.local/share/zsh/user-functions/fzf-key-bindings.zsh || true

lnr_target -s ~/.vim/plugged/fzf/shell/completion.zsh \
~/.local/share/zsh/user-completions/fzf-completions.zsh || true
