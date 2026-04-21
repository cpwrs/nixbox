{
  flake.modules.nixos.niri = {pkgs, ...}: {
    environment = {
      systemPackages = with pkgs; [
        niri
        xwayland-satellite
        wl-clipboard
      ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };

    xdg.portal.configPackages = [pkgs.niri];

    services.displayManager = {
      sessionPackages = [pkgs.niri];
      defaultSession = "niri";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
}
