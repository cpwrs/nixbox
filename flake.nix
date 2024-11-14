{
  description = "NixOS 24.05 config for my desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      # Overlay neovim with the nightly version
      overlays = [
        inputs.neovim-nightly.overlays.default
      ];
    in
    {
      nixosConfigurations = {
        box = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = inputs;
          modules = [
            ./conf.nix
            { nixpkgs.overlays = overlays; } 
          ];
        };
      };
    };
}
