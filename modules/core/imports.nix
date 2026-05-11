{config, ...}: {
  flake.modules.nixos.core.imports = with config.flake.modules.nixos; [
    network
    root
    nix
    age
    yubikey
    man
    direnv
  ];
}
