{pkgs, ...}: {
  imports = [./hardware.nix];
  networking.hostName = "toaster";

  users.users = {
    carson = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      packages = with pkgs; [
        brave # Browser
        mutt # Mail clinet
        typora # Markdown renderer
        gimp # Image editor
        gemini-cli # AI agent
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

  desktop = {
    enableFor = ["carson"];
    compositor = {
      monitors = [",preferred,auto,1"];
      extraConfig = ''
        cursor {
          no_hardware_cursors = 0
          use_cpu_buffer = 1
        }
      '';
    };
    variables = ["LIBVA_DRIVER_NAME,nvidia" "XDG_SESSION_TYPE,wayland" "GBM_BACKEND,nvidia-drm" "__GLX_VENDOR_LIBRARY_NAME,nvidia"];
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
