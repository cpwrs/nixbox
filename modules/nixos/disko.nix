{inputs, ...}: {
  flake.modules.nixos.disko = inputs.disko.nixosModules.disko;
}
