dotfiles
========

Swiss army knife of Software Engineer. Simplifies complex and repetitive
tasks. Save, restore & sync configurations.

This repository is a collection of system configurations and tools for all my
tasks in coding, admin and general system use.

Install
-------

Installing means just creating the relative symbolic links to right locations
in `$HOME` or `$XDG_CONFIG_HOME` for the system software to use the
configuration and run command scripts i.e. `~/.bashrc`, `~/.zshrc`,
`~/.vimrc`.

For this just run `./install` in `dotfiles` repository root directory.

Uninstall
---------

Uninstalling means just removing the relative symbolic links from the
installed locations.

For this just run `./uninstall` in `dotfiles` repository root directory.

Why do we need this repository?
-------------------------------

As Software Engineers we tend to use command line (CLI) more for our daily
tasks such as reading and writing code and documentation.

When some command or a group of commands for a given task is too hard to
remember in its raw form we create an alias, a function or a binary script for
each of its variant so that it is easy to remember to type it or search for it
in command line history.

Over time these custom commands, aliases and plugins become too many to keep
them in a single file for each software and also as the software version
changes so does the configuration and associated custom commands that needs to
be updated.

So we create this repository and keep all the scripts and configurations here.
Use git to version the changes and sync across machines by cloning. Any system
we use it must have all these functionalities and boost our productivity
significantly.

Below are some example use cases to help us understand the need for this
repository.

### Example 1: Check date & time

Checking date time with timezone in raw form requires us to remember this
format string which is hard and error prone due to typing mistake.

```bash
$ date +"%Y-%m-%dT%H:%M:%S%z"
2024-01-22T12:30:06+0530
```

This is simplified by adding an alias that is easy to remember, type or search
in command line history.

```bash
alias dtz='date +"%Y-%m-%dT%H:%M:%S%z"'

$ dtz
2024-01-22T12:30:06+0530
```

This is further added to the text editor `vim` as a keymap and an
abbreviation so it can be inserted into text files or source code.

```vim
" Insert date
nnoremap <Leader>dt          "=strftime('%Y-%m-%dT%H:%M:%S%z')<cr>p
inoremap <C-\>d              <C-O>"=strftime('%Y-%m-%dT%H:%M:%S%z')<cr>p
iabbrev <expr> dtz           strftime('%Y-%m-%dT%H:%M:%S%z')
```

### Example 2: Create relative symbolic links

When installing a software package or binary without root permissions we may
need to create symbolic links relative to the target directory where we want
to install.

For this task the raw command as below and it is hard to remember and error
prone when typing.

```bash
ln "$opt" "$(realpath --relative-to="$rl_dst" "$src")" "$dst"
```

This is simplified by adding a function in `~/.bashrc` or `~/.zshrc` as below
and then create aliases for shorter form.

```bash
lnr () {
	local opt="$1"
	local rl_dst="$2"
	local src="$3"
	local dst="$4"
	ln "$opt" "$(realpath --relative-to="$rl_dst" "$src")" "$dst"
}

_lnrb () {
	local opt="$1"
	local src="$2"
	local dst="$HOME/.local/bin"
	lnr "$opt" "$dst" "$src" "$dst"
}

alias lnrb='_lnrb -s '
alias lnrbf='_lnrb -sf '
```

Now installing a binary such as `bat` is simple as:

```bash
lnrb ~/Downloads/softwares/bat

$ file ~/.local/bin/bat
~/.local/bin/bat: symbolic link to ../../Downloads/softwares/bat/
```

### Example 3: Search for aliases

Add a simple function search for aliases using `grep` to filter through the
search pattern and use `less` to page through with colors to view the aliases.

```bash
aliasg () {
	alias | grep --color=always "$@" | less -r -F
}

$ aliasg 'date'
dtts='date +"%Y-%m-%d-%H-%M-%S"'
dtymd='date +"%Y-%m-%d"'
dtz='date +"%Y-%m-%dT%H:%M:%S%z"'

$ aliasg 'git' | wc -l
121
```

There are many more such simplified commands, aliases, custom functions and
utilities for software engineer tasks in this repository and can be easily
understood from the code and comments in code.

Design
------

Ideally there is no need to design the `dotfiles` file layout and code as they
are just simple collection of configurations and scripts. This is what I had
done initially. Started simple and added shell and vim scripts over time.

So only for these shell and vim scripts I had to design the file layout and
create some conventions such as plugins to keep the code modular and scalable.

The design of the scripts file layout is based on Unix philosophies:

* One tool for one task and each tool must be a filter to allow chaining of
  the commands.
* Make each tool work together to create the Integrated Development
  Environment a.k.a. IDE.

### Shell scripts plugins

Plugins in shell scripts are just normal scripts that are designed to be
sourced into main shell configuration scripts `~/.zshrc` or `~/.bashrc`.

They are used to separate the related code for a given tool or a task into a
single script so that it becomes easy to debug, look up or detach if needed.

For example the code for git aliases and custom functions are grouped into a
single script `git.plugin.sh` and sourced into shell common scripts. Here git
doesn't depend on a specific shell so it is sourced into shell common but the
plugin for `fzf` tool depends on the shell so it is sourced into
`fzf.plugin.zsh` in zshrc parts scripts.

File layout
-----------

`dotfiles` file layout is based on grouping the task or use case related
scripts such as aliases, plugins, keymaps and options into their units that
are later sourced into main shell configuration scripts.

### Shell scripts file layout

```bash
$ tree -L 3 --charset ascii
|-- dot-config
|   `-- zshrcparts
|       |-- aliases
|       |-- completions
|       |-- keymaps
|       |-- plugins
|       `-- prompt
|-- dot-zshrc
```

### Vim scripts file layout

```bash
$ tree -L 2 dot-config/nvim
dot-config/nvim
|-- after
|   `-- syntax
|-- autoload
|   |-- custom
|   `-- statusline
|-- lua
|   |-- init.lua
|   |-- lsp
|   `-- plugins
|-- plugin
|   |-- custom.vim
|   `-- statusline.vim
|-- autocmds.vim
|-- colors.vim
|-- init.vim
|-- keymaps.vim
|-- options.vim
`-- plugins.vim
```
