{pkgs, ...}: {
  imports = [./hardware.nix];
  networking.hostName = "toaster";

  users.users = {
    carson = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      packages = with pkgs; [
        brave # Browser
        mutt # Mail client
        typora # Markdown renderer
        gimp # Image editor
        gemini-cli # AI agent
        d-spy
        ghostty
      ];
    };
  };

  terminal = {
    enableFor = ["carson"];
    emulator = {
      font_size = 12;
      line_height = 0.9;
      padding = [7 7 7 7];
    };
  };

  programs.niri.enable = true;
  systemPackages = with pkgs; [
    wl-clipboard
    quickshell
    bibata-cursors
  ];
  sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  hardware = {
    graphics = {
      enable32Bit = true;
      enable = true;
    };
  };

  # Nvidia on Wayland...
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };
}
