{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4" = {
    gpio.enable = true;
  };
}
