dotfiles
========
My dotfiles based on [chezmoi](https://www.chezmoi.io).

Quickstart
----------
```zsh
xcode-select -p &>/dev/null || xcode-select --install
mkdir -p ~/.local/bin
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin
~/.local/bin/chezmoi init --apply  ~sr.ht/~pethin/dotfiles
```
