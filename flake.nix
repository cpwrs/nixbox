{
  description = "NixOS 24.05 config for my desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    neovim.url = "github:crpowers/envy";
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let system = "x86_64-linux"; 
    in {
      nixosConfigurations = {
        box = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs.inputs = inputs;
          modules = [
            ./conf.nix
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
