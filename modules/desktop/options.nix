{lib, ...}:
with lib; {
  options.desktop = {
    enableFor = mkOption {
      type = types.listOf (types.str);
      description = ''
        Name(s) of user(s) to enable the desktop suite for.
        This module is for enabling and configuring my entire wayland desktop suite.
        Includes the Hyprland compositor, Bibata cursor set, hyprpaper wallpaper engine,
        hyprshot screenshot tool, wl-clipboard, Xwayland compatibility, and the QuickShell toolkit.
      '';
    };

    hyprland = {
      monitors = mkOption {
        type = types.listOf types.str;
        default = [",preferred,auto,1"];
        description = "List of monitor configurations. See https://wiki.hypr.land/Configuring/Monitors/.";
      };
      border_size = mkOption {
        type = types.int;
        default = 1;
        description = "Size of the border around windows";
      };
      rounding = mkOption {
        type = types.int;
        default = 10;
        description = "Rounded corner's radius (in layout px)";
      };
      gaps = mkOption {
        type = types.int;
        default = 10;
        description = "Gaps between windows";
      };
      mouse_sensitivity = mkOption {
        type = types.float;
        default = 0.0;
        description = "-1.0 to 1.0, 0 means no modification. See https://wiki.hyprland.org/Configuring/Variables/#input.";
      };
      binds = mkOption {
        type = types.listOf (types.str);
        default = [];
        description = ''List of hyprland binds. Must include "bind[flags] = ". See https://wiki.hypr.land/Configuring/Binds/.'';
      };
    };

    wallpaper = mkOption {
      type = types.path;
      default = ./dotfiles/wallpaper.jpg;
      description = "Wallpaper file";
    };

    cursor_size = mkOption {
      type = types.int;
      default = 20;
      description = "Size of the cursor";
    };

    variables = mkOption {
      type = types.listOf (types.str);
      default = [];
      description = ''Environment variables to set when the compositor starts. Ex: [ "__NV_DISABLE_EXPLICIT_SYNC,1" ]'';
    };
  };
}
