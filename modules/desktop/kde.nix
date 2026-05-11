{inputs, ...}: {
  flake.modules.nixos.kde = {pkgs, ...}: {
    imports = [inputs.qtengine.nixosModules.default];
    programs.qtengine = {
      enable = true;

      config = {
        theme = {
          colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeLight.colors";
          iconTheme = "breeze";
          style = "breeze";
          fontFixed.family = "Berkeley Mono SemiCondensed";
          fontFixed.size = 12;
          font.family = "Inter";
          font.size = 12;
        };

        misc = {
          singleClickActivate = false;
          menusHaveIcons = true;
          shortcutsForContextMenus = true;
        };
      };
    };

    qt = {
      enable = true;
      platformTheme = null;
    };

    security.polkit.enable = true;
    systemd = {
      user.services.polkit-agent = {
        wants = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        qt6.qtwayland
        qt6.qtsvg
        kdePackages.breeze
        kdePackages.breeze.qt5
        kdePackages.breeze-icons
        kdePackages.dolphin
        kdePackages.okular
        kdePackages.filelight
      ];
    };

    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = ["kde"];
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        kdePackages.xdg-desktop-portal-kde
      ];
      xdgOpenUsePortal = true;
    };
  };
}
