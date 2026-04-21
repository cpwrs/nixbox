{
  flake.modules.nixos.core = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      git
      wget
      zip
      unzip
      btop
      fd
      jq
      ripgrep
      binutils
      pciutils
      usbutils
      vim
    ];
  };
}
