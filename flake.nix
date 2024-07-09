{
	description = "NixOS 24.05 config for my desktop";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		neovim.url = "github:crpowers/envy";
		nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
	};

	outputs = { self, nixpkgs, nixos-wsl, ... } @ inputs: {
		nixosConfigurations = {
			box = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				# Pass all inputs to the modules.
				specialArgs.inputs = inputs;
				modules = [
					nixos-wsl.nixosModules.default
					./conf.nix
				];
			};
		};	
	};
}
