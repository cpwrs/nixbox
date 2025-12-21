{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    # Custom kernel for surface
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];

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

    # https://github.com/NixOS/nixos-hardware/issues/1685
    kernelPatches = [{
      name = "rust-1.91-fix";
      patch = ./rust-fix.patch;
    }];
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    microsoft-surface.kernelVersion = "stable";
    nvidia = {
      # Can't use open drivers, this card doesn't have GSP firmware
      open = false;
      modesetting.enable = true;
    };
  };
}
