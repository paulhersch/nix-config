{
	description = "Flake for my Systems";
	
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
		unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs =
		{ self
		, nixpkgs
		, ...
		}@inputs:
		with nixpkgs.lib;
		let
			config = {
				allowUnfree = true;
			};

			overlays = with inputs; [
				# copied this from ft2k, i guess this delays the eval of system until the attribute is set or smth
				(final: _: let inherit (final) system; in {
					unstable = import unstable { inherit config system; };
				})
				inputs.nixpkgs-f2k.overlays.default
			];

			shared-modules = [
				./configuration.nix
				inputs.home-manager.nixosModule
				{
					nixpkgs = { inherit config overlays; };
				}
			];
		in
		{
			nixosConfigurations = {
				snowstorm = nixosSystem {
					system = "x86_64-linux";
					modules = shared-modules ++ [
						./hosts/snowstorm.nix
					];
				};
				snowflake = nixosSystem {
					system = "x86_64-linux";
					modules = shared-modules ++ [
						./hosts/snowflake.nix
					];
				};
			};
		};
}
