{ pkgs, inputs, ... }:
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
    inputs.private-fonts.packages.${pkgs.system}.default
  ];

  documentation = {
    dev.enable = true;
  };
}
