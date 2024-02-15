# shellcheck shell=bash disable=1090 disable=SC2034
# zsh keymaps file, to be sourced into ~/.zshrc

# configure key keybindings
bindkey -e                                                # emacs key bindings

# custom command keybindings
bindkey -s '^X^[t' 'tmxr\n'                               # ctrl-x alt-t
bindkey -s '^X^[s' 'source ~/.zshrc\n'                    # ctrl-x alt-s
