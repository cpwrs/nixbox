{
  config,
  inputs,
  lib,
  ...
}: {
  flake.nixosConfigurations.surface = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      core
      surface

      desktop
      dev
    ];
  };

  flake.modules.nixos.surface = {...}: {
    system.stateVersion = "25.11";
    time.timeZone = "America/Chicago";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    services.brightness.enable = true;
    services.evremap = {
      enable = true;
      settings = {
        device_name = "Microsoft Surface Keyboard";
        phys = "usb-0000:00:14.0-1.3/input0";
        dual_role = [
          {
            input = "KEY_CAPSLOCK";
            hold = ["KEY_LEFTCTRL"];
            tap = ["KEY_ESC"];
          }
        ];
      };
    };
  };
}
