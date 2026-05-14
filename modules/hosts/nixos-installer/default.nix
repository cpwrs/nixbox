{
  config,
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with config.flake.modules.nixos; [
      installer
    ];
  };

  flake.modules.nixos.installer = {...}: {
    imports = ["${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"];
    users.users.root.openssh.authorizedKeys.keys = builtins.attrValues self.keys.yubikeys;
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    networking.firewall.allowedTCPPorts = [22];
  };
}
