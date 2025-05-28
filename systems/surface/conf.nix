{ inputs, pkgs, ... }:
{
  # Windows stuff
	wsl = {
		enable = true;
		wslConf.interop.appendWindowsPath = false;
		defaultUser = "carson";
		startMenuLaunchers = true;
	};

  # Allow unfree software and flakes
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.allowed-users = [ "carson" ];
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Automatically build the immutable man page cache
  documentation.man.generateCaches = true;
 
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

  # Add users and their packages
  users = {
    users = {
      carson = {
        isNormalUser = true;
        extraGroups  = [ "wheel" ];
        packages = with pkgs; [
					htop
          lazygit
          pfetch
          ripgrep
          gh
          fzf
        ] ++ (with inputs; [
          envy.packages.${pkgs.system}.default
        ]);
      };
    };
  };

	# Global packages
  environment.systemPackages = with pkgs; [ 
    tmux
    git
    unzip
    zip
    wget
    vim
    man-pages
    man-pages-posix
  ];
 
  system.stateVersion = "25.05";
}
