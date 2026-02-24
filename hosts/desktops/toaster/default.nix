{...}: {
  networking.hostName = "toaster";
  imports = [./hardware.nix];

  system.stateVersion = "25.11";
}
