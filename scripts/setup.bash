#!/usr/bin/env bash

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
mkdir -pv ~/.local/share/{ba,z}sh/user-{completions,functions}

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

if [ "$XDG_CURRENT_DESKTOP" = "xfce" ]; then
	install_config configs/xfce/local/share/xfce4/helpers/xtm.desktop \
		~/.local/share/xfce4/helpers/

	install_config configs/xfce/config/autostart/Terminal.desktop \
		~/.config/autostart/
fi

if [ -f /usr/lib/git-core/git-sh-prompt ]; then
       safe_link /usr/lib/git-core/git-sh-prompt ~/.local/lib/git-sh-prompt
else
       wget -q --show-progress -O ~/.local/lib/git-sh-prompt  \
       https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh
fi

safe_link /usr/bin/fdfind ~/.local/bin/fd
safe_link /usr/bin/batcat ~/.local/bin/bat

lnr_bin -s ~/.vim/plugged/fzf/bin/fzf || true

# TODO support bash shell for package generated autocompletions
lnr_target -s ~/.vim/plugged/fzf/shell/key-bindings.zsh \
~/.local/share/zsh/user-functions/fzf-key-bindings.zsh || true

lnr_target -s ~/.vim/plugged/fzf/shell/completion.zsh \
~/.local/share/zsh/user-completions/fzf-completions.zsh || true

setup_uv() {
	local shell comp_dir
	# TODO move this to common location
	shell=$(basename "$SHELL")
	comp_dir="$HOME/.local/share/$shell_name/user-completions"

	mkdir -p "$comp_root"

	for c in uv uvx; do
		if command -v "$c" >/dev/null 2>&1; then
			f="$comp_dir/${c}.${shell}"
			"$c" generate-shell-completion "$shell" > $f
		fi
	done
}

setup_uv
