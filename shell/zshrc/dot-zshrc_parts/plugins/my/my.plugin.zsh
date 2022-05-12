# My aliases and functions

# source common file
if [ -f ~/.zshrc_parts/common/common.zsh ]; then
    . ~/.zshrc_parts/common/common.zsh
fi

# --- paths ---

# --- aliases ---
# workspace aliases
export mydp="$mwp/mydocs"
export myrp="$mwp/myrepos"
export mybp="$myrp/blog/manid2.gitlab.io"

alias mydp="cd \"$mydp\""
alias myrp="cd \"$myrp\""
alias mybp="cd \"$mybp\""

# --- functions ---

# --- aliases ---
# aliases for above functions
