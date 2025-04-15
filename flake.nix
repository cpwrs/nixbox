{
  description = "NixOS 24.05 config for my desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    envy.url = "github:crpowers/envy";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... } @ inputs:
    let system = "x86_64-linux"; 
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs.inputs = inputs;
          modules = [
            ./systems/desktop/conf.nix
          ];
        };

        surface = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs.inputs = inputs;
          modules = [
            nixos-wsl.nixosModules.default
            ./systems/surface/conf.nix
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
