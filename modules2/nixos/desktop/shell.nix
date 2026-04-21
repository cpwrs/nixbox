{
  flake.modules.nixos.shell = {pkgs, ...}: {
    environment = {
      systemPackages = with pkgs; [
        quickshell
        bibata-cursors
      ];
    };
  };
}
