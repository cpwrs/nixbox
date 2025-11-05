{...}: {
  imports = [
    ./meta.nix
    ./networking.nix
    ./ssh.nix
  ];
  system.stateVersion = "25.11";
  time.timeZone = "America/Chicago";
}
