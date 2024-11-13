{
  description = "NixOS 24.05 config for my desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";    
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      # Overlay neovim with the nightly version
      overlays = [
        neovim-nightly.overlays.default
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
