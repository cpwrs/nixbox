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
    # pinctrl_sunrisepoint needs to be loaded before soc_button_array
    # for power and volume rocker presses to be recognized
    extraModprobeConfig = ''
      softdep soc_button_array pre: pinctrl_sunrisepoint
    '';
  };

  time.timeZone = "America/Chicago";

  programs = {
    dconf.enable = true;
    gnupg.agent.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
  
  # Fix for Electron apps defaulting to X11
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services = {
    # Get function keys working
    # Only for root functions - user ones are setup by hyprland
    actkbd = {
      enable = true;
      bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -U 10"; } # Brightness down
        { keys = [ 225 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -A 10"; } # Brightness up
      ];
    };

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
        extraGroups  = [ "wheel" "networkmanager" ];
        packages = with pkgs; [
          brave         # Browser
          htop          # Pretty process viewer
          pfetch        # Pretty system info
          ripgrep       # Grep dirs respectfully
          gh            # GitHub CLI
          fzf           # Fuzzy find lists
          hyprpaper     # IPC Wallpaper util
          hyprshot      # Screenshots
          hyprcursor    # Cursor format
          quickshell    # Desktop shell
          wl-clipboard  # CLI copy/paste utils
          lazygit       # Git CLI
          mutt          # Mail client
          wezterm       # Terminal
          typora        # Markdown renderer
          gimp          # Image editor
        ] ++ (with inputs; [
          envy.packages.${pkgs.system}.default # Personal neovim config
        ]);
      };
    };
  };

  environment.systemPackages = with pkgs; [
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
