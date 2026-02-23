{pkgs, ...}: {
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
    settings = {
      extra-substituters = [
        "https://cache.garnix.io"
        "https://cache.nixos.org"
      ];

      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      experimental-features = [
        "flakes"
        "nix-command"
      ];

      http-connections = 50;
      show-trace = true;
      warn-dirty = false;
      trusted-users = ["root" "@build" "@wheel" "@admin"];
    };
    channel.enable = false;
  };

  environment.systemPackages = with pkgs; [nh];
}
