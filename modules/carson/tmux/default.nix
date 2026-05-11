{
  flake.modules.nixos.carson = {pkgs, ...}: let
    sesh = pkgs.writeShellApplication {
      name = "sesh";
      runtimeInputs = with pkgs; [tmux fzf findutils gnused gawk coreutils];
      text = builtins.readFile ./sesh.sh;
    };
  in {
    users.users.carson.packages = [pkgs.tmux sesh];
    hjem.users.carson.xdg.config.files = {
      "tmux/tmux.conf" = {
        source = ./tmux.conf;
        clobber = true;
      };
    };
  };
}
