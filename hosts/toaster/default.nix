{pkgs, ...}: {
  networking.hostName = "toaster";
  imports = [./hardware.nix];

  users.users = {
    carson = {
      isNormalUser = true;
      extraGroups = ["wheel" "video"];
      packages = with pkgs; [
        pkgs.nur.repos.Ev357.helium
        typora
        gimp
        opencode
        ghostty
        d-spy
        zathura
        zoom-us
        obs-studio
        ffmpeg_6
        obsidian
      ];
    };
  };
}
