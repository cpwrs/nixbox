{pkgs, ...}: {
  networking.hostName = "toaster";

  imports = [
    ./hardware.nix
    ../../modules/desktop.nix
    ../../modules/devtools.nix
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
