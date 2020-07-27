# dotfiles

`dotfiles` repo to save and share system settings and configs.

> NOTE: Use with caution as not all parts of the dotfiles are tested.

Copy and paste the required parts of the dotfiles.

`master` branch contains settings and info common to all systems.\
System specific settings are stored in their respective directories.\
Branch based settings storage is reverted due to difficulty in merging
the common settings.

## Tips

* Use `stow` to install dotfiles.

  ```bash
  stow --dotfiles bashrc -t ~/
  stow --dotfiles vimrc -t ~/

  # result
  # ls -la ~/
  # .bash-m -> ../../home/.../dotfiles/bashrc/dot-bash-m/
  # .bashrc -> ../../home/.../dotfiles/bashrc/dot-bashrc
  # .vimrc  -> ../../home/.../dotfiles/vimrc/dot-vimrc
  ```

* FIXME: `stow` not deleting sym links for dot-config packages.

## Notes

* Commit only formatted, compact and working state code.
* Use `tmp/*` with `WIP: <commit-msg>` commits for unclean commits.
* `tmp/*` branches are used for syncing temporary WIP code.
* Use `shfmt` to format shell scripts.
* Use `shellcheck` to lint shell scripts.
* Use `cloc` to count source code line stats.
* Use `ruby-github-linguist` from apt in ubuntu to get language stats.

## TODO

* Write `install.sh` script to install dotfiles in below cases.
  * When GNU `stow` is available.
  * When no gnu stow use own logic to create sym links.
* Update `README.md` on how to install.
