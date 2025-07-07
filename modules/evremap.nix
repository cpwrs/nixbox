# Module to start up evremap with a given config
{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.evremap;
in {
  options.evremap = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable evremap";
    };
    config = mkOption {
      type = types.path;
      description = "Evremap configuration toml";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      evremap
    ];

    systemd.services.evremap = {
      description = "Evremap service";
      wantedBy = ["multi-user.target"];
      restartTriggers = [ cfg.config ];

      serviceConfig = {
        User = "root";
        Group = "root";
        ExecStart = "${pkgs.evremap}/bin/evremap remap ${cfg.config}";
        Restart = "always";
        WorkingDirectory = "/";
      };
    };
  };
}
