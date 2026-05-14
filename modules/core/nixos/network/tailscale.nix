{
  flake.modules.nixos.tailscale = {config, ...}: {
    services.tailscale = {
      enable = true;
      interfaceName = "ts0";
    };
    networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [22];
  };
}
