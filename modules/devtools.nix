{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      inputs.envy.packages.${pkgs.system}.default
      tmux
      git
      vim
      gdb
      python3

      pciutils
      psmisc
      usbutils
      lazygit
      gh
      btop
      wget
      zip
      unzip
      jq
      fd
      fzf
      ripgrep
      stow

      man-pages
      man-pages-posix
    ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  documentation = {
    man.enable = true;
  };

  # Don't build the immutable cache every rebuild
  # Just once weekly at 4AM
  systemd.services."build-man-cache" = {
    description = "Build the immutable man pages cache";
    startAt = "Sun 04:00";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    path = [pkgs.coreutils];
    script = ''
      mkdir -p /var/cache/man/nixos
      ${pkgs.man-db}/bin/mandb
    '';
  };
}
