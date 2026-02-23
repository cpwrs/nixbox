{
  config,
  lib,
  ...
}: {
  users.extraGroups.networkmanager.members = lib.attrNames config.users.users;
  networking = {
    resolvconf.enable = false;
    # Enable NetworkManager, but don't allow it to manage DNS.
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        backend = "iwd";
      };
      dns = lib.mkForce "none";
      settings = {
        main = {systemd-resolved = false;};
      };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [22]; # SSH
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve.DNSOverTLS = "opportunistic";
  };
  services.tailscale.enable = true;
}
