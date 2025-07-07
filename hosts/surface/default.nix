{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    # Custom kernel for surface
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];
  networking.hostName = "surface";

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
    emulator = {
      font_size = 20;
      padding = [4 4 4 4];
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

  # Start evremap as root for capslock = ctrl (hold) or esc (tab)
  evremap = {
    enable = true;
    config = ./evremap.toml;
  };
}
