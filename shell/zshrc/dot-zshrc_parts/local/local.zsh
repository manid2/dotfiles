# add user local bin path
path=($HOME/.local/bin $path)

# put all user local apps in this script.
if [ -f ~/.local/bin/user-local-apps ]; then
    source ~/.local/bin/user-local-apps
fi