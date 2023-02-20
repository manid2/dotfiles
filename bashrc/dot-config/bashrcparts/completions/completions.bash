# source fzf auto completions
if [ -f ~/.vim/plugged/fzf/shell/completion.bash ]; then
	source ~/.vim/plugged/fzf/shell/completion.bash
fi

# map custom commands to matching command completions
complete -o default -o nospace -F _man vman
complete -o default -o nospace -F _man yman
complete -o default -o nospace -F _sudo ysdo
