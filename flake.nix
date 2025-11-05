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
      "nix-command"
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
    forEachSystem = fn:
      nixpkgs.lib.genAttrs
      nixpkgs.lib.platforms.linux
      (system: fn system nixpkgs.legacyPackages.${system});
  in rec {
    nixosConfigurations = {
      toaster = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/toaster
          ./modules/common
          ./modules/desktop.nix
          ./modules/devtools.nix
        ];
      };
      surface = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/surface
          ./modules/common
          ./modules/desktop.nix
          ./modules/devtools.nix
        ];
      };
      sd-image = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs.inputs = inputs;
        modules = [
          ./images/sd-image.nix
          ./modules/devtools.nix
          {nixpkgs.hostPlatform = {system = "aarch64-linux";};}
        ];
      };
    };

    packages.aarch64-linx.sd-image = nixosConfigurations.sd-image.config.system.build.sdImage;

    devShells = forEachSystem (system: pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.nixd
          pkgs.alejandra
        ];
      };
    });
  };
}
