{
  flake.modules.nixos.yubikey = {pkgs, ...}: {
    services.pcscd.enable = true;
    services.udev.packages = [pkgs.yubikey-personalization];
    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      libfido2
    ];
  };
}
