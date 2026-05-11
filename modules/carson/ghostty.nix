{
  flake.modules.nixos.carson = {pkgs, ...}: {
    users.users.carson.packages = [pkgs.ghostty];
    hjem.users.carson.xdg.config.files = {
      "ghostty/config" = {
        source = ./.ghostty;
        clobber = true;
      };
    };
  };
}
