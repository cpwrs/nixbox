{config, ...}: {
  flake.modules.nixos.core.imports = with config.flake.modules.nixos; [
    network
    users
    nix
  ];
}
