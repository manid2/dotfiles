# source fzf key bindings
fzf_key_bindings=~/.local/share/zsh/user-functions/fzf-key-bindings.zsh
if [ -f $fzf_key_bindings ]; then
	source $fzf_key_bindings
else
	return 1
fi

# fzf check spelling with dictionary preview.
# shellcheck disable=SC2120
fzf_spell () {
	local cmd="command cat /usr/share/dict/words 2>/dev/null"

	local fzf_opts="--height ${FZF_TMUX_HEIGHT:-40%} "
	fzf_opts+="--prompt 'dict> ' --reverse --border --ansi "
	fzf_opts+="--preview-label 'Dictionary' --preview-window '80%,wrap' "
	fzf_opts+="--preview 'dictls {}' ${FZF_DEFAULT_OPTS-}"

	eval "$cmd" | FZF_DEFAULT_OPTS="$fzf_opts" $(__fzfcmd) -m "$@" | \
		xargs -d "\n" -I {} echo -n "{} " | xclip -sel clip -i

	local ret=$?
	return $ret
}

fzf-spell-widget () {
	fzf_spell
	local ret=$?
	zle reset-prompt
	return $ret
}

# alt+[ s
zle     -N              fzf-spell-widget
bindkey -M emacs '^[[s' fzf-spell-widget
bindkey -M vicmd '^[[s' fzf-spell-widget
bindkey -M viins '^[[s' fzf-spell-widget
