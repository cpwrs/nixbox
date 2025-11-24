{
  config,
  lib,
  ...
}: {
  users.extraGroups.networkmanager.members = lib.attrNames config.users.users;
  networking = {
    resolvconf.enable = false;
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        backend = "iwd";
      };
      dns = lib.mkForce "none";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=1.1.1.1 1.0.0.1
      Domains=~.
    '';
  };
  systemd.network.enable = true;
  services.tailscale.enable = true;
  systemd.network.networks."99-tailscale" = {
    matchConfig.Name = "tailscale0";
    networkConfig = {
      DNS = "100.100.100.100" ;
      Domains = "~ts.net";
    };
  };
}
