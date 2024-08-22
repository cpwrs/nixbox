{ config, inputs, lib, pkgs, ... }:
{
	wsl = {
		enable = true;
		wslConf.interop.appendWindowsPath = false;
		defaultUser = "carson";
		startMenuLaunchers = true;
	};

  # Allow unfree software and flakes.
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.allowed-users = [ "carson" ];
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
 
  # Set timezone.
  time.timeZone = "America/Chicago";
  
  programs = {
    gnupg.agent.enable = true;
    bash.enableLsColors = false;
    nix-ld.enable = true;

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
