{ pkgs, ... }:
{
  # System packages
  environment.systemPackages = with pkgs; [ 
    stow
    tmux
    git
    unzip
    zip
    wget
    vim
    xclip
    xlockmore
    man-pages
    man-pages-posix
    iw
  ];

  fonts.packages = [
    pkgs.nerd-fonts.hack
  ];

  documentation = {
    dev.enable = true;
  };
}
