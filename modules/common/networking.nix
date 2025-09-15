{
  config,
  lib,
  ...
}: let
  inherit (lib) attrNames;
in {
  users.extraGroups.networkmanager.members = attrNames config.users.users;
  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };
}
