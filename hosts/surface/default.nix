{
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "surface";

  imports = [
    ./hardware.nix
    ../../modules/common
    ../../modules/nvidia.nix
    ../../modules/niri.nix
    # Custom kernel for surface
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];

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
      ];
    };
  };

  services = {
    # Get root function keys working
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

    # Powersaving / thermals
    thermald.enable = true;
    tlp.enable = true;
  };

  # Start evremap as root for capslock = crtl (hold) or esc (tap)
  environment.systemPackages = with pkgs; [
    evremap
  ];
  systemd.services.evremap = {
    description = "evremap-service";
    wantedBy = ["multi-user.target"];
    restartTriggers = [./evremap.toml];

    serviceConfig = {
      User = "root";
      Group = "root";
      ExecStart = "${pkgs.evremap}/bin/evremap remap ${./evremap.toml}";
      Restart = "always";
      WorkingDirectory = "/";
    };
  };
}
