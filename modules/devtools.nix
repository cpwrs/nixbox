{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      inputs.envy.packages.${pkgs.system}.default
      tmux
      git
      vim
      gdb
      python3

      pciutils
      psmisc
      usbutils
      lazygit
      gh
      btop
      wget
      zip
      unzip
      jq
      fd
      fzf
      ripgrep

      clang-tools
      rust-analyzer
      typescript-language-server
      nixd
      texlab
      gopls
      pyright
      lua-language-server
      svelte-language-server
    ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
