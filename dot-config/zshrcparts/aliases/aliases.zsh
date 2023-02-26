# zsh aliases file, to be sourced into ~/.zshrc

# short alias to history
alias hst='history'
# detailed history using zsh built-in fc
alias hstd="fc -lt '%d-%m-%Y %H:%M:%S %s'"
# Alias to print history without cmd num
alias hstnn="history | sed 's/^[[:space:]]*[[:digit:]]*[[:space:]]*//g'"
