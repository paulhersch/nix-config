{
	description = "Flake for my Systems";
	
	inputs = {
		nixos.url = "github:nixos/nixpkgs/nixos-21.11";
		unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixos";
		};
	};

	outputs =
		{ self
		, nixos
		, unstable
		, nixpkgs-f2k
		, home-manager
		}:
		with nixos.lib;
		let
			overlays = with inputs; [
				(final: prev: {
					unstable = import unstable { inherit config system; };
				})
				nixpkgs-f2k.overlays.default
			];
		in
		{
			nixosConfigurations = {
				snowstorm = nixos.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [ ./configuration.nix ./hosts/desktop.nix ];
				};
				snowflake = nixos.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [
						nixos
						home-manager
						./configuration.nix
						./hosts/desktop.nix
					];
				};
			};
		};
}
