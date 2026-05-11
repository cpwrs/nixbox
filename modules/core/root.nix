{
  flake.modules.nixos.root = {
    users = {
      mutableUsers = false;
      users.root = {
        # No login to root
        hashedPassword = "!";
      };
    };
  };
}
