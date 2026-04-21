{
  flake.modules.nixos.users = {
    users = {
      users = {
        root = {
          isSystemUser = true;
        };

        carson = {
          isNormalUser = true;
          extraGroups = ["wheel"];
        };
      };
    };
  };
}
