# zsh plugins file, to be sourced into ~/.zshrc

# TODO: use ohmyzsh style plugins handler to enable disable using simple
# plugin names instead of complete path to plugin scripts where popssible.

# Source zsh-autosuggestions plugin if available
# NOTE: this should be sourced at the end as suggested in official docs
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# Source command-not-found plugin if available
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi
