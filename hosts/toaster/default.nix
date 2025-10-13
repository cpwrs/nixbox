{pkgs, ...}: {
  networking.hostName = "toaster";

  imports = [
    ./hardware.nix
    ../../modules/niri.nix
    ../../modules/polkit.nix
    ../../modules/nvidia.nix
    ../../modules/devtools.nix
    ../../modules/common
  ];

  users.users = {
    carson = {
      isNormalUser = true;
      extraGroups = ["wheel" "video"];
      packages = with pkgs; [
        brave
        typora
        gimp
        opencode
        ghostty
        d-spy
        zathura
        zoom-us
        discord
        obs-studio
        ffmpeg_6
      ];
    };
  };
}
