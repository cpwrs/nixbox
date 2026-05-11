{
  flake.modules.nixos.graphics = {pkgs, ...}: {
    hardware.graphics = {
      enable32Bit = true;
      enable = true;
    };
  };
}
