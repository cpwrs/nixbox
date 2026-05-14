{inputs, ...}: {
  flake.modules.nixos.age = inputs.agenix.nixosModules.default;
}
