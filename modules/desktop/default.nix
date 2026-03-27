# All the essentials for my desktop!
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./devtools.nix
    ./networking.nix
    ./ssh.nix
    inputs.qtengine.nixosModules.default
  ];

  users.users.carson = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"];
    packages = with pkgs; [
      inputs.helium.packages.${pkgs.system}.helium
      gimp
      opencode
      ghostty
      d-spy
      hotspot
      zathura
      wireshark
      obs-studio
      ffmpeg_6
      obsidian
      kdePackages.dolphin
      kdePackages.okular
      kdePackages.kcalc
    ];
  };

  # KDE
  programs.qtengine = {
    enable = true;

    config = {
      theme = {
        colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
        iconTheme = "breeze-dark";
        style = "breeze";
        fontFixed.family = "Berkeley Mono SemiCondensed";
        fontFixed.size = 12;
        font.family = "DejaVu Sans";
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

  # Wayland compositor, graphical shell, cursors, clipboard, and Qt!
  environment = {
    systemPackages = with pkgs; [
      niri
      xwayland-satellite
      wl-clipboard
      bibata-cursors
      quickshell

      qt6.qtwayland
      kdePackages.breeze
      kdePackages.breeze.qt5
      kdePackages.breeze-icons
      qt6.qtsvg
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
