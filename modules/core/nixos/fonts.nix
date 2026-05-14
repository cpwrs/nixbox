{
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts = {
      packages = with pkgs; [
        dejavu_fonts
        inter
        nerd-fonts.jetbrains-mono

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-lgc-plus
        noto-fonts-color-emoji
      ];

      fontconfig.enable = false;
    };

    console = {
      earlySetup = true;
      font = "Lat2-Terminus16";
      packages = [pkgs.terminus_font];
    };
  };
}
