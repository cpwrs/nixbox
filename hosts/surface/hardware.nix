{...}: {
  imports = ["hardware-configuration.nix"];

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

  hardware.microsoft-surface.kernelVersion = "stable";
}
