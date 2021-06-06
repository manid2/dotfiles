# zsh plugins file, to be sourced into ~/.zshrc

# Using ohmyzsh style plugins handler to enable/disable plugin using simple
# names instead of complete path to plugin scripts where possible.

# Add plugins to {zshrc}/{plugins}/{plugin}/
# Use {plugin}.plugin.zsh file name as used in OMZ plugins.
# NOTE: plugins should not interfer with performance or have conflicting
# functions.

# plugins=(
#    adb
#    alias-finder
#    autopep8
#    battery
#    bazel
#    bgnotify
#    bundler
#    common-aliases
#    debian
#    docker-compose
#    docker
#    encode64
#    extract # omz plugin, extracts archives, conflicts with apt pkg
#    extract # apt pkg, extracts meta info
#    golang
#    helm
#    jfrog
#    jira
#    kubectl
#    nmap
#    node
#    npm
#    npx
#    perl
#    pip
#    python
#    salt
#    systemadmin
#    systemd
#    tig
#    zsh-completions # zsh-users plugin, use only selected files, e.g. cmake
#  )
#

# Example format: plugins=(git bundler debian apt aliasfinder)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    my
)

# code borrowed from ohmyzsh/oh-my-zsh.sh plugins handler
is_plugin() {
  local base_dir=$1
  local name=$2
  builtin test -f $base_dir/plugins/$name/$name.plugin.zsh
}

# Add all defined plugins to fpath. This must be done before running compinit.
# zshrc parts dir "~/.zshrc_parts"
# plugins path "~/.zshrc_parts/plugins/{plugin}/{plugin}.plugin.zsh"
for plugin ($plugins); do
    if is_plugin ~/.zshrc_parts $plugin; then
        fpath=(~/.zshrc_parts/plugins/$plugin $fpath)
    else
        echo "ZSHRC_PARTS_DIR plugin '$plugin' not found"
    fi
done

# Source all plugins
for plugin ($plugins); do
    if [ -f ~/.zshrc_parts/plugins/$plugin/$plugin.plugin.zsh ]; then
        source ~/.zshrc_parts/plugins/$plugin/$plugin.plugin.zsh
    fi
done

# Source command-not-found plugin if available
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi
