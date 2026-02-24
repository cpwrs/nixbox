{pkgs, ...}: {
  networking.hostName = "pi";
  imports = [
    ./hardware.nix
    ./disk.nix
  ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  users.users = {
    carson = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9+4cvvVu5SOVi1/rxU6xhUcBAhW9frDaE0TI5MXrIX carson@toaster"
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443]; # SSH, HTTP, HTTPS
    };
  };

  services.resolved.enable = true;
  services.tailscale.enable = true;

  system.stateVersion = "25.11";
}
