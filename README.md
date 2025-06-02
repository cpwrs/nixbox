NixOS 25.05 configurations for my desktop and laptop.

```bash
sudo nixos-rebuild --flake .#<system-name> switch
stow -t $HOME -d systems/<system-name>/dotfiles
```
