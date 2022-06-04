# source shell common file
if [ -f ~/.config/shellcommon/common/common.sh ]; then
	source ~/.config/shellcommon/common/common.sh
fi

# --- aliases ---
# workspace aliases
export mydp="$mwp/mydocs"
export myrp="$mwp/myrepos"
export mybp="$myrp/manid2.gitlab.io"

alias mydp="cd \"$mydp\""
alias myrp="cd \"$myrp\""
alias mybp="cd \"$mybp\""
