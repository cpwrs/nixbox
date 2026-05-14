{
  flake.modules.nixos.man = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
    ];

    documentation = {
      man.enable = true;
      man.cache.generateAtRuntime = true;
      doc.enable = false;
      info.enable = false;
      nixos.enable = false;
    };
  };
}
