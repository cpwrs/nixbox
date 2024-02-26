{
	description = "Unix-like OS & dev environment";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs, ... } @ inputs: {
		nixosConfigurations = {
			nixos = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				# Pass all inputs to the modules.
				specialArgs = inputs;
				modules = [
					./conf.nix
				];
			};
		};	
	};
}
