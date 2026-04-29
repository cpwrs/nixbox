{inputs, ...}: {
  flake.modules.nixos.age = {
    pkgs,
    lib,
    ...
  }: {
    imports = lib.lists.singleton inputs.agenix.nixosModules.default;
    environment.systemPackages = with pkgs; [
      inputs.agenix.packages.${pkgs.system}.default
      age
    ];
  };
}
