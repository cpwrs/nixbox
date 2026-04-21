{inputs, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      inputs.helium.packages.${pkgs.system}.default
      ghostty
      zathura
      obs-studio
      obsidian
      thunderbird
      wireshark
      gimp
    ];
  };
}
