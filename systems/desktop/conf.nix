{ inputs, pkgs, ... }:
{
  imports = [ 
    ./hardware.nix # Auto-generated hardware stuff
  ];

  nix = {
    settings.allowed-users = [ "carson" ];
  };

  # Use the systemd-boot EFI boot loader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    }; 
  };

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
      # I just use run startx from the shell after login if needed
      displayManager.startx.enable = true;

      # Tiling window manager
      windowManager.spectrwm.enable = true;
      
      # US keyboard layout
      xkb = {
        layout = "us";
      };
    };

    # Audio handling
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh.enable = true;
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

  # Add carson and his packages
  users = {
    users = {
      carson = {
        isNormalUser = true;
        extraGroups  = [ "wheel" ];
        packages = with pkgs; [
          chromium    # Browser
          rofi        # Menu
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
          gimp        # Image editor
        ] ++ (with inputs; [
          envy.packages.${pkgs.system}.default # Personal neovim config
        ]);
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "box";

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
