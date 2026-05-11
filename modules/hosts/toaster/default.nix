{
  config,
  inputs,
  ...
}: let
  host = {
    name = "toaster";
    stateVersion = "25.11";
    system = "x86_64-linux";
  };
in {
  flake.nixosConfigurations.toaster = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      core
      toaster
      carson
      desktop
      dev
      nvidia
      disko
    ];
  };

  flake.modules.nixos.toaster = {inherit host;};
}
