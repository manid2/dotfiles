# Inital code borrowed from ohmyzsh/plugins/git plugin
# Extensively modified to make it practical and readable.
# Its easy to remember the readable commands than the random aliases.
# So most aliases & functions from the OMZ git plugin are removed/modified.
# And they are fine tuned to my workflows.

# NOTE: Use this plugin along with `git-sh-prompt` script from 'git-core'
# for git status in the prompt line.

# --- aliases ---
# aliases for git commands
alias ga='git add'
alias gb='git branch'
alias gbv='git branch -vv'
alias gcm='git commit'
alias gcma='git commit --amend'
alias gcmv='git commit -v'
alias gcho='git checkout'
alias gchb='git checkout -b'
alias gcfs='git config --list --show-origin'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gd='git diff'
alias gds='git diff --staged'
alias gdmn='git diff --diff-filter=M --name-only'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gfap='git fetch --all --prune'
alias gfp='git fetch --prune'
alias gpl='git pull'
alias gps='git push'
alias gpsf='git push --force'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbo='git rebase --onto'
alias grs='git reset'
alias grsh='git reset --hard'
alias gsh='git show'
alias gshs='git show -s'
alias gst='git status'
alias gam='git am'
alias gamc='git am --continue'
alias gama='git am --abort'
alias gl='git log'
alias gl1='git log -1'
alias glo='git log --oneline'
alias gg='git gui'
alias gk='gitk'

# --- functions ---
# Theese functions should be read-only and should not interfere with other
# processes. `GIT_OPTIONAL_LOCKS` environment variable is equivalent to
# running with `git --no-optional-locks`, but falls back gracefully for older
# versions of git.
#
# Wrap git commands in a local function instead of exporting the variable
# directly in order to avoid interfering with git commands run by the user.

function __git_cmd() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# NOTE: using '--quiet' with 'symbolic-ref' will not cause a fatal error (128)
# if it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(__git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(__git_cmd rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

function git_short_sha() {
  __git_cmd rev-parse --short HEAD 2> /dev/null
}

function git_long_sha() {
  __git_cmd rev-parse HEAD 2> /dev/null
}

function git_get_user_name() {
  __git_cmd config user.name 2>/dev/null
}

function git_get_user_email() {
  __git_cmd config user.email 2>/dev/null
}

# get user name and email info in "name <email>" format
function git_get_user_info() {
  local git_user_info
  local gcue
  local gcun
  gcun=$(git_get_user_name)
  gcue=$(git_get_user_email)
  if [[ -n "$gcun" && -n "$gcue" ]]; then
    git_user_info="$gcun <$gcue>"
    echo $git_user_info
  fi
}

function git_set_user_name() {
  __git_cmd config user.name $1 2>/dev/null
}

function git_set_user_email() {
  __git_cmd config user.email $1 2>/dev/null
}

# TODO: set user name and email info in "name <email>" format
#function git_set_user_info() {
#  local git_user_info=$1
#  # parse and set user name & email.
#}

function git_repo_path() {
  local repo_path=$(__git_cmd rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$repo_path" ]]; then
    echo $repo_path
  fi
}

function git_repo_name() {
  local repo_name
  if repo_name=$(git_repo_path) && [[ -n "$repo_name" ]]; then
    echo ${repo_name:t}
  fi
}

# git branch rename
function gbrn() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
}

# --- aliases ---
# aliases for above functions
alias grpp='git_repo_path'
alias grpn='git_repo_name'
alias gpsu='git push -u origin $(git_current_branch)'

# --- git contrib modules ---
path+=('/usr/share/doc/git/contrib/diff-highlight')
path+=('/usr/share/doc/git/contrib/git-jump')

# aliases to git contrib modules
alias gjd='git jump diff'
alias gjm='git jump merge'
alias gjg='git jump grep'
alias gjw='git jump ws'

# git grep aliases
alias ggrp='git grep -n'

# git diff-highlight aliases
alias gdh='git diff --color | diff-highlight | less -r'

# git paste aliases
alias gpst='git paste2'

# TODO
#
# * Use common files for bash & zsh shells
# * alias: git fetch, pull with --prune option
# * alias: git remote prune branches
# * alias: git worktree add, remove, prune
# * alias: git archive zip, tar
# * alias: git log in mulitple pretty formats
# * function: git blame single file, range in file, multiple files
# * function: git follow single file, range in file, multiple files
# * function: prune remote branches and delete the corresponding 'gone'
#   local branches.
