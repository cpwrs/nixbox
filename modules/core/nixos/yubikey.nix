{
  flake.modules.nixos.yubikey = {pkgs, ...}: {
    services.udev.packages = [pkgs.libfido2];
    environment.systemPackages = with pkgs; [
      yubikey-manager
      libfido2
    ];
  };
}
