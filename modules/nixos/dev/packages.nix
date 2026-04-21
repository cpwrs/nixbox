{inputs, ...}: {
  flake.modules.nixos.dev = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      opencode
      tmux
      gdb
      python3
      lazygit
      nmap
      gh
      stow
      devenv
      kicad-small
      d-spy
      fzf
      hotspot
      inputs.envy.packages.${pkgs.system}.default
    ];
  };
}
