{
  flake.modules.nixos.man = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
    ];

    documentation = {
      man.enable = true;
    };

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
        ${lib.getExe pkgs.man-db}
      '';
    };
  };
}
