{
  flake.modules.nixos.brightness = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.services.brightness;
  in {
    options.services.brightness = {
      enable = lib.mkEnableOption "brightnessctl keybinding service via actkbd";

      upKey = lib.mkOption {
        type = lib.types.int;
        default = 225;
        description = "Key code for brightness up (default: 225, XF86MonBrightnessUp).";
      };

      downKey = lib.mkOption {
        type = lib.types.int;
        default = 224;
        description = "Key code for brightness down (default: 224, XF86MonBrightnessDown).";
      };

      step = lib.mkOption {
        type = lib.types.str;
        default = "10%";
        description = "Brightness adjustment step (e.g., \"10%\", \"5\").";
      };
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [pkgs.brightnessctl];

      services.actkbd = {
        enable = true;
        bindings = [
          {
            keys = [cfg.downKey];
            events = ["key"];
            command = "/run/current-system/sw/bin/systemctl start brightness-down.service";
          }
          {
            keys = [cfg.upKey];
            events = ["key"];
            command = "/run/current-system/sw/bin/systemctl start brightness-up.service";
          }
        ];
      };

      systemd.services.brightness-up = {
        description = "Increase screen brightness";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl set +${cfg.step}";
        };
      };

      systemd.services.brightness-down = {
        description = "Decrease screen brightness";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl set ${cfg.step}-";
        };
      };
    };
  };
}
