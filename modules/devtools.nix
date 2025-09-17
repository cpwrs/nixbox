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
      gdb
      usbutils
      ffmpeg_6
      psmisc
      pciutils

      # LSP
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
