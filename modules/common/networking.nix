{
  config,
  lib,
  ...
}: {
  users.extraGroups.networkmanager.members = lib.attrNames config.users.users;
  networking = {
    networkmanager.enable = true;
    # Cloudflare
    nameservers = ["1.1.1.1" "1.0.0.1"];
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };
}
