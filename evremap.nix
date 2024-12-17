{ config, inputs, lib, pkgs, ... }: {
  systemd.services.myservice = {
    description = "Evremap service";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      WorkingDirectory = "/";
      ExecStart = "${pkgs.evremap}/bin/evremap remap /home/carson/.config/evremap/evremap.toml -d 0";
      Restart = "always";
    };
  };
}
