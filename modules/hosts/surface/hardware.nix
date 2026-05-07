{inputs, ...}: {
  flake.modules.nixos.surface = {
    imports = [
      inputs.nixos-hardware.nixosModules.microsoft-surface-common
    ];

    hardware.facter.reportPath = ./facter.json;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/d594f08b-b184-4f94-bc4b-ad11b27b9ae7";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/1B5F-0679";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [];

    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
      };

      # pinctrl_sunrisepoint needs to be loaded before soc_button_array
      # for power and volume rocker presses to be recognized
      extraModprobeConfig = ''
        softdep soc_button_array pre: pinctrl_sunrisepoint
      '';
    };

    # Can't use open drivers, this card doesn't have GSP firmware
    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      microsoft-surface.kernelVersion = "stable";
      nvidia = {
        open = false;
        modesetting.enable = true;
      };
    };
  };
}
