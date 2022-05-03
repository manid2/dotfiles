# My aliases and functions

# source common file
if [ -f ~/.bashrc_parts/common/common.sh ]; then
    . ~/.bashrc_parts/common/common.sh
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
