{
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = ["4:00"];
    };
    settings = (import ../../flake.nix).nixConfig;
    channel.enable = false;
  };

  environment.systemPackages = with pkgs; [nh];
}
