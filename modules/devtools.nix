{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      tmux
      git
      zip
      unzip
      wget
      vim
      btop
      ripgrep
      gh
      jq
      fzf
      lazygit
      inputs.envy.packages.${pkgs.system}.default
    ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
