# Niri compositor and dependencies
{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      niri
      wl-clipboard
      bibata-cursors
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
}
