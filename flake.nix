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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    forEachSystem = fn:
      nixpkgs.lib.genAttrs
      nixpkgs.lib.platforms.linux (
        system: fn nixpkgs.legacyPackages.${system}
      );
  in rec {
    nixosConfigurations = {
      toaster = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/toaster
          ./modules/common
          ./modules/desktop.nix
          ./modules/devtools.nix
          inputs.nur.modules.nixos.default
        ];
      };
      surface = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/surface
          ./modules/common
          ./modules/desktop.nix
          ./modules/devtools.nix
          inputs.nur.modules.nixos.default
        ];
      };
      pi = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/pi
          ./modules/common
          ./modules/devtools.nix
          inputs.disko.nixosModules.disko
        ];
      };
      sd-image = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        modules = [
          ./images/sd-image.nix
        ];
      };
    };

    packages.aarch64-linux.sd-image = nixosConfigurations.sd-image.config.system.build.sdImage;

    devShells = forEachSystem (pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.nixd
          pkgs.alejandra
        ];
      };
    });
  };
}
