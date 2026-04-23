{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
    ./dev-shell.nix
    ./systems.nix
  ];
}
