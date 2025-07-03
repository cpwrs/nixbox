{...}: {
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
      dates = ["4:00"];
    };
    settings.trusted-users = ["@wheel"];
  };

  system.stateVersion = "25.05";
}
