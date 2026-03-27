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
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qtengine = {
      url = "github:kossLAN/qtengine";
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
          ./hosts/desktops/toaster
          ./modules/desktop
          ./modules/meta.nix
        ];
      };
      surface = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/desktops/surface
          ./modules/desktop
          ./modules/meta.nix
        ];
      };
      pi = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        modules = [
          ./hosts/servers/pi
          ./modules/meta.nix
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
