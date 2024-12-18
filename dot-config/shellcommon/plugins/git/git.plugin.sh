#
# Partial code borrowed from ohmyzsh/plugins/git plugin
#

# --- aliases ---
# aliases for git commands
alias ga='git add'
alias gac='git add .'
alias gacm='git add . && git commit'
alias gacmm='git add . && git commit -m'
alias gacv='git add . && git commit -v'
alias gb='git branch'
alias gbv='git branch -vv'
alias gcm='git commit'
alias gcma='git commit --amend'
alias gcmm='git commit -m'
alias gcmv='git commit -v'
alias gcho='git checkout'
alias gchb='git checkout -b'
alias gchod='git checkout dev'
alias gchoe='git checkout exp'
alias gchom='git checkout main'
alias gcls='git config --list --show-origin'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcpx='GIT_EDITOR=gcpx_ed git cherry-pick -xe'
alias gd='git diff'
alias gds='git diff --staged'
alias gdst='git diff --stat'
alias gdss='git diff --staged --stat'
alias gdmn='git diff --diff-filter=M --name-only'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gfap='git fetch --all --prune'
alias gfp='git fetch --prune'
alias gfpm='git fetch --prune && git merge'
alias gg='git -c core.pager=less grep -n'
alias gpl='git pull'
alias gps='git push'
alias gpsa='git push --all'
alias gpsd='git push --delete'
alias gpsf='git push --force'
alias gpsp='git push --prune'
alias gpst='git push --tags'
alias gpsaf='git push --all --force'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbm='git rebase main'
alias grbim='git rebase --interactive main'
alias grbo='git rebase --onto'
alias grs='git reset'
alias grsh='git reset --hard'
alias grs1='git reset @~'
alias grsh1='git reset --hard @~'
alias grsu1='git reset @{u}'
alias grsuh1='git reset --hard @{u}'
alias grv='git remote -vv'
alias gsh='git show'
alias gshs='git show -s'
alias gshb='git show -s --pretty="%B"'
alias gshpf='git show -s --pretty=fuller'
alias gsas='git status'
alias gsth='git stash'
alias gstm='git stash -m'
alias gstl='git stash list'
alias gstd='git stash drop'
alias gstp='git stash pop'
alias gsta='git stash apply'
alias gstc='git stash clear'
alias gam='git am'
alias gamc='git am --continue'
alias gama='git am --abort'
alias gl='git log'
alias glm='git log main..'
alias glmb='git log main.. --pretty="%B"'
alias glmpf='git log main.. --pretty=fuller'
alias glu='git log @{upstream}..'
alias glub='git log @{upstream}.. --pretty="%B"'
alias glupf='git log @{upstream}.. --pretty=fuller'
alias gl1='git log -1'
alias gl1b='git log -1 --pretty="%B"'
alias gl1pf='git log -1 --pretty=fuller'
alias gl1p='git log -1 -p'
alias gl1s='git log -1 --stat'
alias gl1f='git log -1 --format="" --name-only'
alias glo='git log --oneline'
alias glom='git log --oneline main..'
alias glou='git log --oneline @{upstream}..'
alias grlc='git rev-list --count HEAD'
alias grlcm='git rev-list --count main..'
alias gls='git ls-files'
alias glsm='git ls-files --modified'
alias glso='git ls-files --others --exclude-standard'
alias gfop='git format-patch'
alias gfopm='git format-patch origin/main..'
alias gfopmt='git format-patch origin/main.. -o /tmp/'
alias ggi='git gui &'
alias ggk='gitk &'

# --- functions ---
# Theese functions should be read-only and should not interfere with other
# processes. `GIT_OPTIONAL_LOCKS` environment variable is equivalent to
# running with `git --no-optional-locks`, but falls back gracefully for older
# versions of git.
#
# Wrap git commands in a local function instead of exporting the variable
# directly in order to avoid interfering with git commands run by the user.

__git_cmd () {
	GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# NOTE: using '--quiet' with 'symbolic-ref' will not cause a fatal error (128)
# if it's not a symbolic ref, but in a Git repo.
git_current_branch () {
	local ref
	ref=$(__git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
	local ret=$?
	if [[ $ret != 0 ]]; then
		[[ $ret == 128 ]] && return  # no git repo.
		ref=$(__git_cmd rev-parse --short HEAD 2> /dev/null) || return
	fi
	echo "${ref#refs/heads/}"
}

git_short_sha () {
	__git_cmd rev-parse --short HEAD 2> /dev/null
}

git_long_sha () {
	__git_cmd rev-parse HEAD 2> /dev/null
}

git_get_user_name () {
	__git_cmd config user.name 2>/dev/null
}

git_get_user_email () {
	__git_cmd config user.email 2>/dev/null
}

# get user name and email info in "name <email>" format
git_get_user_info () {
	local git_user_info
	local gcue
	local gcun
	gcun=$(git_get_user_name)
	gcue=$(git_get_user_email)
	if [[ -n "$gcun" && -n "$gcue" ]]; then
		git_user_info="$gcun <$gcue>"
		echo "$git_user_info"
	fi
}

git_set_user_name () {
	__git_cmd config user.name "$1" 2>/dev/null
}

git_set_user_email () {
	__git_cmd config user.email "$1" 2>/dev/null
}

# set user name and email using "name <email>" format
git_set_user_info () {
	local _git_user_info=$1
	if [[ -z "$_git_user_info" ]]; then
		return
	fi
	# shellcheck disable=SC2016
	local _split_n='echo $_git_user_info | cut -d "<" -f1'
	# shellcheck disable=SC2016
	local _split_e='echo $_git_user_info | cut -d "<" -f2'
	local _trim="awk '{\$1=\$1};1'"

	local _git_user_name _git_user_email
	_git_user_name=$(eval "$_split_n" | eval "$_trim" )
	_git_user_email=$(eval "$_split_e" | tr '>' ' ' | eval "$_trim")
	git_set_user_name "$_git_user_name"
	git_set_user_email "$_git_user_email"
}

git_repo_path () {
	local repo_path
	repo_path=$(__git_cmd rev-parse --show-toplevel 2>/dev/null)
	if [[ -n "$repo_path" ]]; then
		echo "$repo_path"
	fi
}

git_repo_name () {
	local repo_name
	if repo_name=$(git_repo_path) && [[ -n "$repo_name" ]]; then
		echo "${repo_name:t}"
	fi
}

# git branch rename
git_branch_rename () {
	if [[ -z "$1" || -z "$2" ]]; then
		echo "Usage: $0 old_branch new_branch"
		return 1
	fi

	# Rename branch locally
	__git_cmd branch -m "$1" "$2"
}

# prune local branches 'gone' in remotes
git_prune_local_branches () {
	local _fmt="%(refname:short) %(upstream:track) refs/heads/**"
	local _pat='/\[gone\]/'
	local _awk="awk '$_pat {print \$1}'"
	local _lbes _lbes_arr
	_lbes=$(__git_cmd for-each-ref --format="$_fmt" | eval "$_awk" )

	while IFS= read -r line; do
		_lbes_arr+=("$line")
	done <<-EOF
		$_lbes
	EOF

	for _lb in "${_lbes_arr[@]}"
	do
		if [[ -n "$_lb" ]]; then
			echo "Pruning: $_lb"
			__git_cmd branch -D "$_lb"
		fi
	done
}

# compatible with gitlab merge requests
git_mr () {
	__git_cmd fetch "$1" "merge-requests/$2/head:mr/$1/$2" &&
		git checkout "mr/$1/$2"
}

# * try toggle feature branch and its debug branch
# * toggle dev branch and main branch
# useful for debugging feature branch but without making commits in it.
gchd () {
	local _cb _dbg
	_cb=$(git_current_branch)
	_dbg='-debug'
	__git_cmd show-ref --quiet --verify -- "refs/heads/$_cb$_dbg"
	local _has_dbg=$?
	local _m='main'
	local _d='dev'

	# check if current branch is a debug branch
	if [[ "$_cb" == *"$_dbg" ]]; then
		# switch to feature branch
		__git_cmd checkout "${_cb%"$_dbg"}"
	# if current branch is a feature branch
	# then switch to debug branch if it exists
	elif [[ $_has_dbg == 0 ]]; then
		__git_cmd checkout "$_cb$_dbg"
	# check if current branch is 'main'
	elif [[ "$_cb" == "$_m" ]]; then
		# switch to 'dev' branch
		__git_cmd checkout "$_d"
	# check if current branch is 'dev'
	elif [[ "$_cb" == "$_d" ]]; then
		# switch to 'dev' branch
		__git_cmd checkout "$_m"
	fi
}

# git archive
git_tar () {
	local _prefix
	_prefix="$(git_repo_path)"
	_prefix=$(basename "$_prefix")
	__git_cmd archive --format=tar --prefix="$_prefix/" HEAD -o "$_prefix.tar"
}

# --- aliases ---
# aliases for above functions
alias grpp='git_repo_path'
alias cdgp='cd `git_repo_path`'
alias grpn='git_repo_name'
alias gpsu='git push -u origin $(git_current_branch)'
alias gmr='git_mr origin'
alias gmrr='git_mr'
alias gbpr='git_prune_local_branches'
alias gcsun='git_set_user_name'
alias gcsue='git_set_user_email'
alias gcsui='git_set_user_info'
alias gbrn='git_branch_rename'
alias gbrc='git_branch_rename $(git_current_branch)'
alias gfopc='git format-patch origin/$(git_current_branch)..'
alias gfopct='git format-patch origin/$(git_current_branch).. -o /tmp/'
alias glc='git log origin/$(git_current_branch)..'
alias gloc='git log --oneline origin/$(git_current_branch)..'

# aliases to git contrib modules
alias gjd='git jump diff'
alias gjd1='git jump diff @~'
alias gjm='git jump merge'
alias gjg='git jump grep'
alias gjw='git jump ws'

# git diff-highlight aliases
alias gdh='git diff --color | diff-highlight | less -r'

# view git reflog (local changes) in `tig`
alias grfl='git reflog --pretty=raw | tig --pretty=raw'
