# All the essentials for a usable desktop experience
# TODO: Secret agent, quickshell config, 
{pkgs, ...}: {
  hardware.graphics = {
    enable32Bit = true;
    enable = true;
  };

  # KDE polkit agent
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

  # Wayland compositor, graphical shell, cursors, clipboard
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

  # Portals (stuff like screen share, file dialogs)
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

  services.upower.enable = true;

  # Display manager
  services.displayManager = {
    sessionPackages = [pkgs.niri];
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };


  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # A few basic fonts
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      nerd-fonts.jetbrains-mono
      noto-fonts-lgc-plus
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["DejaVu Serif"];
        sansSerif = ["DejaVu Sans"];
        monospace = ["JetBrainsMono Nerd Font"];
      };
    };
  };

  # Sound
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}
