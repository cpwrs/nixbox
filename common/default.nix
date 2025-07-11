{...}: {
  imports = [
    ./meta.nix
    ./networking.nix
    ./pipewire.nix
    ./ssh.nix
    ./bluetooth.nix
  ];

  system.stateVersion = "25.05";
  time.timeZone = "America/Chicago";
}
