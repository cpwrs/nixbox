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
      evremap
    ];
  };

  flake.modules.nixos.surface = {...}: {
    system.stateVersion = "25.11";
    time.timeZone = "America/Chicago";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    services.evremap.configFile = ./evremap.toml;
  };
}
