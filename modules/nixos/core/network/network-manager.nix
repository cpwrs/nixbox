{
  flake.modules.nixos.network-manager = {
    lib,
    config,
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
          connectivity = {uri = "http://nmcheck.gnome.org/check_network_status.txt";};
        };
      };
      firewall = {
        enable = true;
        interfaces.tailscale0.allowedTCPPorts = [22];
      };
    };
  };
}
