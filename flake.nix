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

    builders-usesubstituters = true;
    http-connections = 50;
    show-trace = true;
    trusted-users = ["root" "@build" "@wheel" "@admin"];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    envy.url = "github:cpwrs/envy";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/desktop/conf.nix
          ./hosts/common
        ];
      };

      surface = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.inputs = inputs;
        modules = [
          nixos-hardware.nixosModules.microsoft-surface-common
          ./modules/desktop
          ./modules/terminal
          ./hosts/surface/conf.nix
          ./hosts/common
        ];
      };
    };

    devShells.${system}.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.mkShell {
        packages = [
          pkgs.nixd # nix ls
          pkgs.alejandra
        ];
      };
  };
}
