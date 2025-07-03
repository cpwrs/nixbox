{pkgs, ...}: {
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

  desktop = {
    enableFor = ["carson"];
    compositor = {
      monitors = [",preferred,auto,1.25"];
      border_radius = 12;
      gap_size = 12;
      binds = [
        "bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        "bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "bindl = , XF86AudioPlay, exec, playerctl play-pause"
      ];
    };
  };

  terminal = {
    enableFor = ["carson"];
    font_size = 16;
    padding = [4 4 4 4];
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
    # Get function keys working
    # Only for root functions - user ones are setup by hyprland
    actkbd = {
      enable = true;
      bindings = [
        {
          keys = [224];
          events = ["key"];
          command = "${pkgs.light}/bin/light -U 10";
        } # Brightness down
        {
          keys = [225];
          events = ["key"];
          command = "${pkgs.light}/bin/light -A 10";
        } # Brightness up
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
    wantedBy = ["multi-user.target"];

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
        extraGroups = ["wheel" "networkmanager"];
        packages = with pkgs; [
          brave # Browser
          mutt # Mail client
          typora # Markdown renderer
          gimp # Image editor
          gemini-cli # AI agent
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    evremap # Keyboard input remapper
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
      allowedTCPPorts = [22];
    };
  };

  system.stateVersion = "25.05";
}
