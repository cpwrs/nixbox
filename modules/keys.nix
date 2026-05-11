{...}: {
  flake.keys = {
    hosts = {
      toaster = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBm+MfqJdf0kjwRzT3QPr4srZmYWl5qBbSIgPNLkkXM root@toaster";
      surface = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5al1hlsLRpQxkMaGen3IMFKHSdmW1EhiIwEU/nP0iw root@surface";
    };
    carsons = {
      toaster = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9+4cvvVu5SOVi1/rxU6xhUcBAhW9frDaE0TI5MXrIX carson@toaster";
      surface = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzh/HEQgeasLpvfHLPSqDNpxjFwMdTIRjZoLkfKDm8x carson@surface";
    };
    yubikeys = {
      chain-a = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGz0/cWd0RSuDNKN3XDY8creMcJbZWX5fJOxd/q41zWIAAAACnNzaDpjYXJzb24= yubi@chain";
      backup-a = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOkDkSBKET0B94kIcGXK0C4BwVfPXFMLLKtrbmwOsFlyAAAACnNzaDpjYXJzb24= yubi@backup";
    };
  };
}
