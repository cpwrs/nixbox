{ config, inputs, lib, pkgs, ... }:
{
  # Services, packages, and configurations for my OS. 
 
  # Allow unfree software and flakes.
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.allowed-users = [ "carson" ];
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
 
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Set timezone.
  time.timeZone = "America/Chicago";
  
  programs = {
    gnupg.agent.enable = true;
    bash.enableLsColors = false;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services = {
    openssh.enable = true;
  };

  # Add users and their packages.
  users = {
    users = {
      carson = {
        isNormalUser = true;
        extraGroups  = [ "wheel" ];
        packages = [
	  pkgs.htop
          pkgs.pfetch
          pkgs.ripgrep
          pkgs.gh
          inputs.neovim.packages.x86_64-linux.default
        ];
      };
    };
  };

	# Global packages
  environment.systemPackages = [ 
    pkgs.tmux
    pkgs.git
    pkgs.unzip
    pkgs.zip
    pkgs.wget
    pkgs.vim
  ];
 
  system.stateVersion = "24.05";
}
