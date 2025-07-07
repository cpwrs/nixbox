{
  pkgs,
  lib,
  ...
}: {
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
      padding = [4 4 4 4];
    };
  };

  desktop = {
    enableFor = ["carson"];
    compositor = {
      monitors = [",preferred,auto,1"];
    };
  };

  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };
}
