{
  flake.modules.nixos.carson = {pkgs, ...}: {
    users.users.carson.shell = pkgs.bash;
    hjem.users.carson.files = {
      ".bashrc" = {
        source = ./.bashrc;
        clobber = true;
      };
      ".inputrc" = {
        source = ./.inputrc;
        clobber = true;
      };
    };
  };
}
