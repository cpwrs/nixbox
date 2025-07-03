# This module is for enabling and configuring my entire terminal tool suite.
# Provides options to customize the default experience in the wezterm terminal emulator.

{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.terminal;
  weztermConf = import ./configs/wezterm.nix {inherit cfg lib;};
in {
  imports = [./../symlink.nix];

  options.terminal = {
    enableFor = mkOption {
      type = types.listOf (types.str);
      description = "Name(s) of user(s) to enable the terminal tool suite for.";
    };

    font_size = mkOption {
      type = types.int;
      description = "Font size";
      default = 12;
    };

    line_height = mkOption {
      type = types.float;
      description = "Font line height ( 0 - 1.0 )";
      default = 1.0;
    };

    padding = mkOption {
      type = types.listOf types.int;
      description = "Left, right, top, bottom window padding";
      default = [0 0 0 0];
    };
  };

  config = mkIf (cfg.enableFor != []) {
    environment = {
      # Terminal tools
      systemPackages = with pkgs; [
        tmux
        git
        zip
        unzip
        wget
        vim
        man-pages
        man-pages-posix
        htop
        pfetch
        ripgrep
        gh
        fzf
        lazygit
        wezterm
        inputs.envy.packages.${pkgs.system}.default
      ];
    };

    fonts.packages = [pkgs.nerd-fonts.hack];
    documentation = {
      dev.enable = true;
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    # I don't want to build the immutable cache every time
    # Just once weekly at 4AM
    systemd.services."build-man-cache" = {
      description = "Build the immutable man pages cache";
      startAt = "Sun 04:00";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      path = [pkgs.coreutils];
      script = ''
        mkdir -p /var/cache/man/nixos
        ${pkgs.man-db}/bin/mandb
      '';
    };

    symlink = mkMerge (map (user: {
        "/home/${user}/.inputrc" = ./configs/.inputrc;
        "/home/${user}/.bashrc" = ./configs/.bashrc;
        "/home/${user}/.profile" = ./configs/.profile;
        "/home/${user}/.config/git/config" = ./configs/.gitconfig;
        "/home/${user}/.config/tmux/tmux.conf" = ./configs/tmux.conf;
        "/home/${user}/.local/bin" = ./configs/bin;
        "/home/${user}/.config/wezterm/wezterm.lua" = weztermConf;
      })
      cfg.enableFor);
  };
}
