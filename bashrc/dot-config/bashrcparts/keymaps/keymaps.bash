# source fzf key bindings
if [ -f ~/.vim/plugged/fzf/shell/key-bindings.bash ]; then
	source ~/.vim/plugged/fzf/shell/key-bindings.bash
fi

# Map CTRL-L to bash readline command 'clear-display'
# NOTE: Use clear-screen when clear-display is not available e.g. in bash v4.2+
# clear-display readline is available in bash v5.1+
#bind -x '"\C-l": clear-screen;'
bind '"\C-l": clear-display'
