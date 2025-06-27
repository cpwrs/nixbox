{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop;
  hyprlandConf = import ./dotfiles/hyprland.nix {inherit cfg lib;};
  hyprpaperConf = import ./dotfiles/hyprpaper.nix {inherit cfg;};
in {
  config = mkIf (cfg.enableFor != []) {
    environment = {
      # Packages needed for the desktop
      systemPackages = with pkgs; [
        playerctl
        wl-clipboard
        quickshell
        hyprpaper
        hyprcursor
        hyprshot
      ];
      sessionVariables = {
        # Fix for electrion apps defaulting to X11
        NIXOS_OZONE_WL = "1";
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
