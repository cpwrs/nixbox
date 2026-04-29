{
  flake.modules.nixos.users = {config, ...}: {
    age.secrets.password.file = ./password.age;

    users = {
      users = {
        root = {
          isSystemUser = true;
          hashedPasswordFile = config.age.secrets.password.path;
        };

        carson = {
          isNormalUser = true;
          extraGroups = ["wheel"];
          hashedPasswordFile = config.age.secrets.password.path;
        };
      };
    };
  };
}
