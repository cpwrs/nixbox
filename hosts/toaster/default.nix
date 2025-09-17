{pkgs, ...}: {
  networking.hostName = "toaster";

  imports = [
    ./hardware.nix
    ../../modules/niri.nix
    ../../modules/nvidia.nix
    ../../modules/devtools.nix
    ../../modules/common
  ];

  users.users = {
    carson = {
      isNormalUser = true;
      extraGroups = ["wheel" "video"];
      packages = with pkgs; [
        brave # Browser
        mutt # Mail client
        typora # Markdown renderer
        gimp # Image editor
        opencode # AI agent
        ghostty # Terminal
        d-spy
        texliveMedium # TeX Live environment
        zathura # PDF Viewer
      ];
    };
  };
}
