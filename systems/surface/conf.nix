{ inputs, pkgs, ... }:
{
  imports = [ 
    ./hardware.nix # Auto-generated hardware stuff
  ];

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

    # Get function keys working
    # Only for root functions - user ones are in sxhkd
    actkbd = {
      enable = true;
      bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -U 10"; } # Brightness down
        { keys = [ 225 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -A 10"; } # Brightness up
      ];
    };

    # Audio handling
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh.enable = true;

    # Powersaving / thermals
    thermald.enable = true;
    tlp.enable = true;
  };

  # Realtime priorities for pipewire
  security.rtkit.enable = true;

  # Start evremap as root for capslock = ctrl (hold) or esc (tab)
  systemd.services.evremap = {
    description = "Caps lock key remapping";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "root";
      Group = "root";
      ExecStart = "${pkgs.evremap}/bin/evremap remap /home/carson/.config/evremap/evremap.toml";
      Restart = "always";
      WorkingDirectory = "/";
    };
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
  };

  # Add carson and his packages
  users = {
    users = {
      carson = {
        isNormalUser = true;
        extraGroups  = [ "wheel" ];
        packages = with pkgs; [
          brave       # Browser
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
          sxhkd       # X hotkey daemon
        ] ++ (with inputs; [
          envy.packages.${pkgs.system}.default # Personal neovim config
        ]);
      };
    };
  };

  environment.systemPackages = with pkgs; [
    iw        # Wireless configuration
    playerctl # Media player controller
    evremap   # Keyboard input remapper
  ];

  networking = {
    networkmanager.enable = true;
    hostName = "surface";

    wireless.networks = {
      Farcaster = {
        psk = "WelcomeToWifi";
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  system.stateVersion = "25.05";
}
