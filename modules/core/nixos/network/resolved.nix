{
  flake.modules.nixos.resolved = {...}: {
    services.resolved = {
      enable = true;
      settings.Resolve.DNSOverTLS = "opportunistic";
    };
  };
}
