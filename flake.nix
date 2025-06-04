{
  description = "NixOS configurations for my computers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    envy.url = "github:cpwrs/envy";
    private-fonts.url = "git+ssh://git@github.com/cpwrs/fonts";
    nixos-hardware.url = "github:NixOS/nixos-hardware/11f2d9ea49c3e964315215d6baa73a8d42672f06";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... } @ inputs:
    let system = "x86_64-linux"; 
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs.inputs = inputs;
          modules = [
            ./systems/desktop/conf.nix
            ./systems/common
          ];
        };

        surface = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs.inputs = inputs;
          modules = [
            nixos-hardware.nixosModules.microsoft-surface-common
            ./systems/surface/conf.nix
            ./systems/common
          ];
        };
      };	

      devShells.${system}.default =
        let pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in pkgs.mkShell {
          packages = [
            pkgs.nil # nix ls
          ];
        };
    };
}
