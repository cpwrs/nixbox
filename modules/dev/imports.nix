{config, ...}: {
  flake.modules.nixos.dev.imports = with config.flake.modules.nixos; [
    direnv
    man
  ];
}
