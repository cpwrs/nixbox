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
  };

  terminal = {
    enableFor = ["carson"];
    font_size = 12;
    padding = [4 4 4 4];
  };

  desktop = {
    enableFor = ["carson"];
    compositor = {
      monitors = [",preferred,auto,1"];
    };
  };

  time.timeZone = "America/Chicago";

  programs = {
    dconf.enable = true;
    gnupg.agent.enable = true;
  };

  services = {
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
        extraGroups = ["wheel" "networkmanager"];
        packages = with pkgs; [
          brave # Browser
          mutt # Mail clinet
          typora # Markdown renderer
          gimp # Image editor
          gemini-cli # AI agent
        ];
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "toaster";

    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };
}
