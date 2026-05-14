{config, ...}: {
  flake.modules.nixos.core.imports = with config.flake.modules.nixos; [
    network
    root
    nix
    yubikey
    man
    direnv
    sound
    upower
    bluetooth
    fonts
    disko
    age
  ];
}
