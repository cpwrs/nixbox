{config, ...}: {
  flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
    bluetooth
    fonts
    graphics
    kde
    niri
    shell
    sound
    upower
    brightness
  ];
}
