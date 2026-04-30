{
  lib,
  config,
  ...
}:
with lib; let
  hostOptions = {
    name = mkOption {
      type = types.str;
      example = "nixos";
      description = "Host name";
    };

    stateVersion = mkOption {
      type = types.str;
      example = "25.11";
      description = "NixOS state version";
    };

    system = mkOption {
      type = types.str;
      example = "x86_64-linux";
      description = "System architecture";
    };
  };
in {
  flake.modules.nixos.core = {config, ...}: {
    options.host = hostOptions;

    config = {
      system.stateVersion = config.host.stateVersion;
      nixpkgs.hostPlatform = config.host.system;
      time.timeZone = "America/Chicago";
    };
  };
}
