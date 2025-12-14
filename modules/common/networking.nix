{
  config,
  lib,
  ...
}: {
  users.extraGroups.networkmanager.members = lib.attrNames config.users.users;
  networking = {
    resolvconf.enable = false;
    # iNet Wireless Daemon instead of wpa_supplicant
    wireless.iwd.enable = true;
    # Enable NetworkManager, but don't allow it to manage DNS.
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        backend = "iwd";
      };
      dns = lib.mkForce "none";
      settings = {
        main = { systemd-resolved = false; };
      };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [22]; # SSH
    };
  };
  # Use resolved for split DNS, and add cloudflare as the global DNS nameserver
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
    extraConfig = ''
      DNS=2606:4700:4700::1111 2606:4700:4700::1001 1.1.1.1 1.0.0.1
      Domains=~.
    '';
  };
  services.tailscale.enable = true;
}
