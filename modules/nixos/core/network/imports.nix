{config, ...}: {
  flake.modules.nixos.network.imports = with config.flake.modules.nixos; [
    network-manager
    resolved
    ssh
    tailscale
  ];
}
