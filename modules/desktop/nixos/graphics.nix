{
  flake.modules.nixos.graphics = {
    hardware.graphics = {
      enable32Bit = true;
      enable = true;
    };
  };
}
