{modulesPath, ...}: {
  networking.hostName = "nixos-sd-image";
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  services.openssh.enable = true;
  services.avahi.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9+4cvvVu5SOVi1/rxU6xhUcBAhW9frDaE0TI5MXrIX carson@toaster"
  ];

  system.stateVersion = "25.11";
  time.timeZone = "America/Chicago";
}
