{pkgs, ...}: {
  documentation = {
    man.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

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
