{
  config,
  inputs,
  lib,
  ...
}: {
  flake.nixosConfigurations.toaster = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      core
      toaster

      desktop
      dev
      nvidia
    ];
  };

  flake.modules.nixos.toaster = {...}: {
    system.stateVersion = "25.11";
    time.timeZone = "America/Chicago";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
