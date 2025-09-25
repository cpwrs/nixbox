# Niri compositor and dependencies
{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      niri
      xwayland-satellite
      wl-clipboard
      bibata-cursors
      quickshell
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = ["kde"];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      };
    };
    configPackages = [pkgs.niri];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      kdePackages.xdg-desktop-portal-kde
    ];
    xdgOpenUsePortal = true;
  };

  services.displayManager = {
    sessionPackages = [ pkgs.niri ];
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
