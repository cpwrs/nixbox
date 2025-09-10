{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop;
  hyprlandConf = import ./configs/hyprland.nix {inherit cfg lib;};
  hyprpaperConf = import ./configs/hyprpaper.nix {inherit cfg;};
in {
  imports = [./../symlink.nix];

  options.desktop = {
    enableFor = mkOption {
      type = types.listOf (types.str);
      description = "Name(s) of user(s) to enable the desktop suite for.";
      default = [];
    };

    compositor = {
      monitors = mkOption {
        type = types.listOf types.str;
        default = [",preferred,auto,1"];
        description = "List of monitor configurations. See https://wiki.hypr.land/Configuring/Monitors/.";
        example = [
          "DP-1, 1920x1080, 0x0, 1"
          "DP-2, 1920x1080, 1920x0, 1"
        ];
      };

      border_size = mkOption {
        type = types.int;
        default = 1;
        description = "Size of the border around windows";
      };

      border_radius = mkOption {
        type = types.int;
        default = 10;
        description = "Rounded corner's radius (in layout px)";
      };

      gap_size = mkOption {
        type = types.int;
        default = 10;
        description = "Gaps between windows";
      };

      binds = mkOption {
        type = types.listOf (types.str);
        default = [];
        description = ''List of hyprland binds. Must include "bind[flags] = ". See https://wiki.hypr.land/Configuring/Binds/.'';
        example = [
          "bindl = , XF86AudioPlay, exec, playerctl play-pause"
        ];
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Any extra configuration you want inside hyprland.conf";
      };
    };

    wallpaper = mkOption {
      type = types.path;
      default = ./configs/wallpaper.jpg;
      description = "Wallpaper file";
    };

    cursor_size = mkOption {
      type = types.int;
      default = 20;
      description = "Size of the cursor";
    };

    mouse_sensitivity = mkOption {
      type = types.float;
      default = 0.0;
      description = "-1.0 to 1.0, 0 means no modification. See https://wiki.hyprland.org/Configuring/Variables/#input.";
      example = 0.5;
    };

    variables = mkOption {
      type = types.listOf (types.str);
      default = [];
      description = ''Environment variables to set when the compositor starts. Ex: [ "__NV_DISABLE_EXPLICIT_SYNC,1" ]'';
    };
  };

  config = mkIf (cfg.enableFor != []) {
    environment = {
      # Packages needed for the desktop
      systemPackages = with pkgs; [
        wl-clipboard
        quickshell
        hyprpaper
        hyprcursor
        hyprshot
        bibata-cursors
      ];
      sessionVariables = {
        # Fix for electrion apps defaulting to X11
        NIXOS_OZONE_WL = "1";
      };
    };

    hardware = {
      graphics = {
        enable32Bit = true;
        enable = true;
      };
    };

    # Hyprland compositor
    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };

    symlink = mkMerge (map (user: {
        "/home/${user}/.config/hypr/hyprland.conf" = hyprlandConf;
        "/home/${user}/.config/hypr/hyprpaper.conf" = hyprpaperConf;
      })
      cfg.enableFor);
  };
}
