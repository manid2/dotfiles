# zsh keymaps file, to be sourced into ~/.zshrc

# configure key keybindings
bindkey -e                                                # emacs key bindings

# source fzf key bindings
if [ -f ~/.vim/plugged/fzf/shell/key-bindings.zsh ]; then
	source ~/.vim/plugged/fzf/shell/key-bindings.zsh
fi

# custom command keybindings
bindkey -s '^X^[t' 'tmux\n'                               # ctrl-x alt-t
bindkey -s '^X^[s' 'source ~/.zshrc\n'                    # ctrl-x alt-s
