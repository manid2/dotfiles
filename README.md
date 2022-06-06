dotfiles
========

<img src="dotfiles_logo_edited.png"
     alt="dotfiles logo"
     title="dotfiles logo"
     width="320">

Logo based on [jglovier/dotfiles-logo][dotfiles_logo_repo]

`dotfiles` repo to save and share system settings and configs.

Installation
------------

It is easy to install the configuration files using GNU Stow.

Hence the directories are structured so that they are compatible with the
`stow <pkg-name>` installation.

Issues with gnu stow:

* stow does not process directories with 'dot-' prefix. This has been reported
  as a bug on github issues.
* stow is not available with most distros and also can't install on remote
  systems where there is no root permissions.

Due to these issues theres is a need to write make files to automate and mange
installations.

How to install:

Using gnu stow

```sh
$ stow --dotfiles bashrc -t ~/
$ stow --dotfiles vimrc -t ~/
$ ls -la ~/
.bashrc -> ../../home/.../dotfiles/bashrc/dot-bashrc
.vimrc  -> ../../home/.../dotfiles/vimrc/dot-vimrc
```

Use `ln` command

```bash
$ ln -s `realpath --relative-to=$HOME bashrc/dot-bashrc`  ~/.bashrc
$ ln -s `realpath --relative-to=$HOME bashrc/dot-bashrc`  ~/.bashrc
```

Use `install.sh` script

```sh
$ source ./install.sh
$ install_pkgs_to_home
$ install_pkgs_to_config
$ install_ssh
```

TODO: Add 'uninstall' option for each package.

How to uninstall:

Using gnu stow

```bash
stow -D --dotfiles bashrc -t ~/
stow -D --dotfiles vimrc -t ~/
```

Or we can just delete the installed soft links.

<!-- Links -->
[dotfiles_logo_repo]: https://github.com/jglovier/dotfiles-logo "go to jglovier/dotfiles-logo"
