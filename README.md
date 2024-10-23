dotfiles
========
My dotfiles based on [chezmoi](https://www.chezmoi.io). Currently only supports macOS.

Quickstart
----------
```zsh
xcode-select -p &>/dev/null || xcode-select --install
mkdir -p ~/.local/bin
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin
~/.local/bin/chezmoi init --apply git@github.com:pethin/dotfiles.git
```
