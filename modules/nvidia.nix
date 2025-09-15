{...}: {
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics = {
      enable32Bit = true;
      enable = true;
    };
    nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };
}
