### Configurations for my [nixbox](https://github.com/crpowers/nixbox) 

Stack: NixOS -> X11 -> spectrwm -> wezterm -> bash -> tmux -> neovim

#### Install
```sh
git clone --bare git@github:cpwrs/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout main
```
Note: This repository is installed BARE; the alias allows for managing dotfiles anywhere in the working tree.
