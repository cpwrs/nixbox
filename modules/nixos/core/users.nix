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
          openssh.authorizedKeys.keys = [
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGz0/cWd0RSuDNKN3XDY8creMcJbZWX5fJOxd/q41zWIAAAACnNzaDpjYXJzb24= yubi@chain"
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOkDkSBKET0B94kIcGXK0C4BwVfPXFMLLKtrbmwOsFlyAAAACnNzaDpjYXJzb24= yubi@backup"
          ];
        };
      };
    };
  };
}
