{
	description = "Unix-like OS & dev environment";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim.url = "path:/home/carson/flakes/neovim";
	};

	outputs = { self, nixpkgs, ... } @ inputs: {
		nixosConfigurations = {
			nixos = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				# Pass all inputs to the modules.
				specialArgs.inputs = inputs;
				modules = [
					./conf.nix
				];
			};
		};	
	};
}
