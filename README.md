# dotfiles

<img src="dotfiles_logo_edited.png"
    alt="dotfiles logo"
    title="dotfiles logo"
    width="320">

Logo based on [jglovier/dotfiles-logo][dotfiles_logo_repo]

`dotfiles` repo to save and share system settings and configs.

## Installation

Use `stow` to install/uninstall dotfiles.

### Install

```bash
stow --dotfiles bashrc -t ~/
stow --dotfiles vimrc -t ~/

# result
# ls -la ~/
# .bashrc_parts -> ../../home/.../dotfiles/bashrc/dot-bashrc_parts/
# .bashrc -> ../../home/.../dotfiles/bashrc/dot-bashrc
# .vimrc  -> ../../home/.../dotfiles/vimrc/dot-vimrc
```

When gnu stow is not available use `ln` command

```bash
ln -s `realpath --relative-to=$HOME ~/scripts/git-prompt` ~/.bashrc_part_git_prompt_sym_link.sh
ln -s `realpath --relative-to=$HOME ~/scripts/system_specific_settings.sh` ~/.bashrc_part_system_specific_config_sym_link.sh
```

### Uninstall

```bash
stow -D --dotfiles bashrc -t ~/
stow -D --dotfiles vimrc -t ~/

# result
# ls -la ~/
# .
# ..
```

### Tips

Structure the project folder so it is easy to install with gnu stow.
Don't stow directories starting with `_`, use `cp` to overwrite the
corresponding directory. Useful for storing data that requires actual files,
instead of sym links, e.g. `.config/` for apps.

## Notes

* Use `shfmt` to format shell scripts.
* Use `shellcheck` to lint shell scripts.
* Use `cloc` to count source code line stats.
* Use `ruby-github-linguist` from apt in ubuntu to get language stats.
* Use GNU `stow` to manage dotfiles.

## TODO

* Handle softwares info using python script.

<!-- Links -->
[dotfiles_logo_repo]: https://github.com/jglovier/dotfiles-logo "go to jglovier/dotfiles-logo"
