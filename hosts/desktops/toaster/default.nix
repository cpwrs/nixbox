{
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "toaster";
  imports = [./hardware.nix];

  users.users.carson = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"];
    packages = with pkgs; [
      inputs.helium.packages.${pkgs.system}.helium
      gimp
      opencode
      ghostty
      d-spy
      hotspot
      zathura
      wireshark
      obs-studio
      ffmpeg_6
      obsidian
      kdePackages.dolphin
      kdePackages.okular
      kdePackages.filelight
      thunderbird
      kicad
    ];
  };

  system.stateVersion = "25.11";
  time.timeZone = "America/Chicago";
}
