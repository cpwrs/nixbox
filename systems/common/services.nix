{ pkgs, ... }:
{
  # Weekly garbage collection, optimise store at 4AM
  nixpkgs.config.allowUnfree = true;
  nix = {
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
    settings.trusted-users = [ "@wheel" ];
  };

  # I don't want to build the immutable cache every time
  # Just once weekly at 4AM
  systemd.services."build-man-cache" = {
    description = "Build the immutable man pages cache"; 
    startAt = "Sun 04:00";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    path = [ pkgs.coreutils ];
    script = ''
      mkdir -p /var/cache/man/nixos
      ${pkgs.man-db}/bin/mandb
    '';
  };

  system.stateVersion = "25.05";
}
