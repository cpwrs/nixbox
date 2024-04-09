{
	description = "NixOS 24.05 config for my desktop";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim.url = "github:crpowers/envy";
	};

	outputs = { self, nixpkgs, ... } @ inputs: {
		nixosConfigurations = {
			box = nixpkgs.lib.nixosSystem {
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
