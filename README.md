dotfiles
========

`~/.dotfiles` repo to synchronize user configurations.

Install
-------

Use `ln` command

```sh
$ ln -s `realpath --relative-to=$HOME bashrc/dot-bashrc`  ~/.bashrc
```

Use `install.sh` script

```sh
$ ./install.sh
```

Uninstall
---------

Using `find` command

```sh
$ install_dirs=($HOME $HOME/.config $HOME/.ssh)
$ find $install_dirs -maxdepth 1  -type l -exec rm {} +
```

<!-- Links -->
[dotfiles_logo_repo]: https://github.com/jglovier/dotfiles-logo "go to jglovier/dotfiles-logo"
