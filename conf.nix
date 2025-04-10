{ inputs, pkgs, ... }:
{
  # Services, packages, and configurations for my OS. 

  imports = [ 
    ./hardware.nix # Auto-gen hardware stuff
  ];

  # Allow unfree software and enable flakes.
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.allowed-users = [ "carson" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "4:00" ];
    };
  };

  # Automatically build the man immutable cache
  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    }; 
  };

  # Set timezone.
  time.timeZone = "America/Chicago";

  programs = {
    dconf.enable = true;
    gnupg.agent.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];

      # Not using a full display manager, 
      # I just use run startx from the shell after login if needed.
      displayManager.startx.enable = true;

      # Tiling window manager.
      windowManager.spectrwm.enable = true;

      xkb = {
        layout = "us";
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh.enable = true;
  };

  # Add hack nerdfont
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; } )
    ];
  };

  # Video and Sound
  hardware = {
    graphics = {
      enable = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };

  # Add carson and packages.
  users = {
    users = {
      carson = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO/jc8By9E//y7jyoVNy7tcjXFCivtuCl972ZhA1ZSBa me@carsonp.net"
        ];
        extraGroups  = [ "wheel" ];
        packages = with pkgs; [
          chromium    # Browser
          dmenu       # Menu
          htop        # Pretty process viewer
          hsetroot    # Wallpaper app
          pfetch      # Pretty system info
          scrot       # Screenshots
          ripgrep     # Grep dirs respectfully
          gh          # GitHub CLI
          fzf         # Fuzzy find lists
          feh         # Wallpaper app
          lazygit     # Git CLI
          mutt        # Mail clinet
          wezterm     # Terminal
          typora      # Markdown renderer
        ] ++ (with inputs; [
          envy.packages.${pkgs.system}.default # Personal neovim config
        ]);
      };
    };
  };

  # Global packages
  environment.systemPackages = with pkgs; [ 
    tmux            # Multiplexer
    git             # Version control
    unzip           # Extract zips
    zip             # Zip files
    wget            # Download files
    vim             # Text editor
    xclip           # Clipboard CLI
    man-pages       # Add Linux dev manual pages
    man-pages-posix # Add POSIX manual pages (0p, 1p, 3p) 
  ];

  networking = {
    networkmanager.enable = true;
    hostName = "box";

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  system.stateVersion = "24.11";
}
