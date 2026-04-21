{
  flake.modules.nixos.man = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
    ];

    documentation = {
      man.enable = true;
    };

    # Alternative to building the immutable cache every rebuild
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
  };
}
