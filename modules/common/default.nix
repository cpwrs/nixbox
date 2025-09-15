{...}: {
  imports = [
    ./meta.nix
    ./networking.nix
    ./pipewire.nix
    ./ssh.nix
    ./bluetooth.nix
    ./docs.nix
    ./fonts.nix
  ];

  system.stateVersion = "25.05";
  time.timeZone = "America/Chicago";
}
