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
      dns = "systemd-resolved";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=2606:4700:4700::1111 2606:4700:4700::1001 1.1.1.1 1.0.0.1
      DNSOverTls=opportunistic
      Domains=~.
    '';
  };
  services.tailscale.enable = true;
}
