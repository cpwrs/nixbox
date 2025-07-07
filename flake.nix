{
  description = "NixOS configurations for my computers";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://cache.nixos.org"
    ];

    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];

    experimental-features = [
      "flakes"
    ];

    http-connections = 50;
    show-trace = true;
    warn-dirty = false;
    trusted-users = ["root" "@build" "@wheel" "@admin"];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    envy.url = "github:cpwrs/envy";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) mapAttrs mapAttrsToList const;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    allModules = mapAttrsToList (name: _: ./modules/${name}) (readDir ./modules);
  in {
    nixosConfigurations = mapAttrs (name:
      const (nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        modules =
          allModules
          ++ [./hosts/${name} ./common];
      })) (readDir ./hosts);

    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.nixd # nix ls
        pkgs.alejandra
      ];
    };
  };
}
