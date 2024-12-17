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

	outputs = { self, nixpkgs, ... } @ inputs: {
		nixosConfigurations = {
			box = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs.inputs = inputs;
				modules = [
					./conf.nix
				];
			};
		};	
	};
}
