{inputs, ...}: {
  flake.modules.nixos.carson = {pkgs, ...}: {
    users.users.carson.packages = with pkgs; [
      opencode
      gdb
      python3
      lazygit
      nmap
      gh
      devenv
      kicad-small
      d-spy
      fzf
      hotspot
      inputs.envy.packages.${pkgs.system}.default
      inputs.helium.packages.${pkgs.system}.default
      zathura
      obs-studio
      obsidian
      thunderbird
      wireshark
      gimp

    ];
  };
}
