# shellcheck disable=SC1090
# source fzf auto completions
if [ -f ~/.vim/plugged/fzf/shell/completion.bash ]; then
	source ~/.vim/plugged/fzf/shell/completion.bash
fi

# source bash style completion scripts
for comp_file in ~/.local/share/bash/user-completions/*.bash; do
	if [ -f "$comp_file" ]; then
		source "$comp_file"
	fi
done

# map custom commands to matching command completions
complete -o default -o nospace -F _man vman
complete -o default -o nospace -F _man nman
complete -o default -o nospace -F _man yman
complete -o default -o nospace -F _sudo ysdo
