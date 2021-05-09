# Generic shell manual setup info

Manual setup gives more control, less bloat and can be managed easily.

List of all possible shell modifications at high level arranged in ascending
alphabetical order.

## Ideal shell setup

Ideally we want each type of settings to be isolated and easy to plug in/out.
But in practice this is not easily possible as tools come with their own
scripts and their own file paths. So practical setup is more simplified and
also easily manageable.

* aliases
* autosuggestions:
  * zsh-autosuggestions (apt pkg)
    `/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh`
* common
* completions
  * zsh-completions (use on need basis)
* configs
* functions
* keymaps
* options
* plugins
* prompt
* syntax-highlighting:
  * zsh-syntax-highlighting (apt pkg)
    `/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`

## Practical shell setup info

```text
# After install we get
#
# ~/.bashrc -> dotfiles/shell/bashrc/dot-bashrc
# ~/.bashrc_parts -> dotfiles/shell/bashrc/dot-bashrc_parts/

# TODO: refactor bashrc directory names and files in below order.
dotfiles/
    `-- shell/
        |-- bashrc/
        |   |-- dot-bashrc_parts/
        |   |   |-- aliases/
        |   |   |   `-- aliases.bash
        |   |   |-- common/
        |   |   |   `-- colors.bash
        |   |   |-- completions/
        |   |   |   `-- completions.bash
        |   |   |-- configs/
        |   |   |   `-- configs.bash
        |   |   |-- keymaps/
        |   |   |   `-- keymaps.bash
        |   |   |-- options/
        |   |   |   `-- options.bash
        |   |   |-- plugins/
        |   |   |   `-- plugins.bash
        |   |   |-- prompt/
        |   |   |   `-- prompt.bash
        |   |   `-- theme/
        |   `-- dot-bashrc
        `-- README.md

# After install we get
#
# ~/.zshrc -> dotfiles/shell/zshrc/dot-zshrc
# ~/.zshrc_parts -> dotfiles/shell/zshrc/dot-zshrc_parts/

dotfiles/
    `-- shell/
        |-- zshrc/
        |   |-- dot-zshrc_parts/
        |   |   |-- aliases/
        |   |   |   `-- aliases.zsh
        |   |   |-- common/
        |   |   |   `-- colors.zsh
        |   |   |-- completions/
        |   |   |   `-- completions.zsh
        |   |   |-- configs/
        |   |   |   `-- configs.zsh
        |   |   |-- keymaps/
        |   |   |   `-- keymaps.zsh
        |   |   |-- options/
        |   |   |   `-- options.zsh
        |   |   |-- plugins/
        |   |   |   `-- plugins.zsh
        |   |   |-- prompt/
        |   |   |   `-- prompt.zsh
        |   |   `-- theme/
        |   `-- dot-zshrc
        `-- README.md
```
