# bash plugins file, to be sourced into ~/.bashrc

# source common file
if [ -f ~/.bashrc_parts/common/common.sh ]; then
    . ~/.bashrc_parts/common/common.sh
fi

# Using ohmyzsh style plugins handler to enable/disable plugin using simple
# names instead of complete path to plugin scripts where possible.

# Add plugins to {bashrc}/{plugins}/{plugin}/
# Use {plugin}.plugin.sh file name as used in OMZ plugins.
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
)

# Source all plugins
for plugin in "${plugins[@]}"; do
    if [ -f ~/.bashrc_parts/plugins/$plugin/$plugin.plugin.sh ]; then
        source ~/.bashrc_parts/plugins/$plugin/$plugin.plugin.sh
    fi
done
