{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.allowed-users = [ "carson" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "4:00" ];
    };
  };

  system.stateVersion = "25.05";
}
