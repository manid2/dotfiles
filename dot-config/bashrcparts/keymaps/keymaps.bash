# shellcheck disable=SC1090
# source fzf key bindings
if [ -f ~/.vim/plugged/fzf/shell/key-bindings.bash ]; then
	source ~/.vim/plugged/fzf/shell/key-bindings.bash
fi

bind '"\C-l": clear-screen'                     # Ctrl-l
bind '"\C-xa": alias-expand-line'               # Ctrl-x a
bind -x '"\C-x\es": "source ~/.bashrc"'         # Ctrl-x Alt-s
