{...}: {
  imports = [./hardware-configuration.nix];

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
