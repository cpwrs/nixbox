{
  flake.modules.nixos.graphical-shell = {pkgs, ...}: {
    environment = {
      systemPackages = with pkgs; [
        quickshell
        bibata-cursors
      ];
    };
  };
}
