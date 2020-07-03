# dotfiles

`dotfiles` repo to save and share system settings and configs.

> NOTE: Use with caution as not all parts of the dotfiles are tested.

Copy and paste the required parts of the dotfiles.

`master` branch contains settings and info common to all systems.\
System specific settings are stored in their respective directories.\
Branch based settings storage is reverted due to difficulty in merging
the common settings.

## Notes

* Commit only formatted, compact and working state code.
* Use `tmp/*` with `WIP: <commit-msg>` commits for unclean commits.
* `tmp/*` branches are used for syncing temporary WIP code.

## TODO

* Use command line tools for `formatting` and `linting` for all langs.
* Use `cloc`, `github-linguist` for collecting stats in the repo.
* Write `install.sh` script to install dotfiles in below cases.
  * When GNU `stow` is available.
  * When no gnu stow use own logic to create sym links.
* Update `README.md` on how to install.
