{config, ...}: {
  flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
    graphics
    kde
    niri
    graphical-shell
    brightness
  ];
}
