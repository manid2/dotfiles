# shellcheck shell=bash disable=1090 disable=SC2034
# zsh keymaps file, to be sourced into ~/.zshrc

# configure key keybindings
bindkey -e                                                # emacs key bindings

# source fzf key bindings
if [ -f ~/.vim/plugged/fzf/shell/key-bindings.zsh ]; then
	source ~/.vim/plugged/fzf/shell/key-bindings.zsh

	# fzf check spelling with dictionary preview.
	# shellcheck disable=SC2120
	__fspell () {
		local cmd="command cat /usr/share/dict/words 2>/dev/null"
		local item
		eval "$cmd" | \
		    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} \
		    --prompt 'dict> ' --reverse --border --ansi \
		    --preview-label 'Dictionary' --preview-window '80%,wrap' \
		    --preview 'dictls {}' \
		    ${FZF_DEFAULT_OPTS-}" $(__fzfcmd) -m "$@" | \
		    xargs -d "\n" -I {} echo -n "{} " | \
		    xclip -sel clip -i
		local ret=$?
		return $ret
	}

	fzf-spell-widget () {
		__fspell
		local ret=$?
		zle reset-prompt
		return $ret
	}

	# alt+[ s
	zle     -N              fzf-spell-widget
	bindkey -M emacs '^[[s' fzf-spell-widget
	bindkey -M vicmd '^[[s' fzf-spell-widget
	bindkey -M viins '^[[s' fzf-spell-widget
fi

# custom command keybindings
bindkey -s '^X^[t' 'tmux\n'                               # ctrl-x alt-t
bindkey -s '^X^[s' 'source ~/.zshrc\n'                    # ctrl-x alt-s
