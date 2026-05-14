{
  flake.modules.nixos.root = {
    users = {
      mutableUsers = false;
      users.root.hashedPassword = "!";
    };
  };
}
