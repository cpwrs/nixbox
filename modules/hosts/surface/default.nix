{
  config,
  inputs,
  ...
}: let
  host = {
    name = "surface";
    stateVersion = "25.11";
    system = "x86_64-linux";
  };
in {
  flake.nixosConfigurations.surface = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      surface
      core
      carson
      desktop
    ];
  };

  flake.modules.nixos.surface = {...}: {
    inherit host;
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
