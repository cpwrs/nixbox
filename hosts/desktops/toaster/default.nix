{...}: {
  networking.hostName = "toaster";
  imports = [./hardware.nix];

  system.stateVersion = "25.11";
  time.timeZone = "America/Chicago";
}
