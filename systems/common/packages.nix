{ pkgs, ... }:
{
  # System packages
  environment.systemPackages = with pkgs; [ 
    stow            # Dotfile manager
    tmux            # Multiplexer
    git             # Version control
    unzip           # Extract zips
    zip             # Zip files
    wget            # Download files
    vim             # Text editor
    xclip           # Clipboard CLI
    xlockmore       # Screensaver (spectr needs this?)
    man-pages       # Add Linux dev manual pages
    man-pages-posix # Add POSIX manual pages (0p, 1p, 3p) 
  ];

  # For man-pages: build immutable cache 
  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };
}
