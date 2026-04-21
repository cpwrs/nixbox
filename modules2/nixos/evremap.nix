{
  flake.modules.nixos.evrmap = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.services.evremap = {
      configFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to the evremap TOML configuration file.";
      };
    };

    config = {
      environment.systemPackages = with pkgs; [
        evremap
      ];
      systemd.services.evremap = {
        description = "evremap-service";
        wantedBy = ["multi-user.target"];
        restartTriggers = [config.services.evremap.configFile];
        serviceConfig = {
          User = "root";
          Group = "root";
          ExecStart = "${pkgs.evremap}/bin/evremap remap ${config.services.evremap.configFile}";
          Restart = "always";
          WorkingDirectory = "/";
        };
      };
    };
  };
}
