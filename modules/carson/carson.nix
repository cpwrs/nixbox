{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos.carson = {config, ...}: {
    age.secrets.password.file = ./password.age;

    users.users.carson = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      hashedPasswordFile = config.age.secrets.password.path;
      # Allow SSH between carson's when a YubiKey is present
      openssh.authorizedKeys.keys = builtins.attrValues self.keys.yubikeys;
    };

    imports = [inputs.hjem.nixosModules.default];
    hjem.users.carson.enable = true;
  };
}
