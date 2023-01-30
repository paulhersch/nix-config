{
	description = "Flake for my Systems";
	
	inputs = {
		nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;
		unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
		nixpkgs-f2k.url = github:fortuneteller2k/nixpkgs-f2k;
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		#helix.url = github:SoraTenshi/helix/experimental;
		nix-gaming.url = github:fufexan/nix-gaming;
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
				nixpkgs-f2k.overlays.default
				(final: prev: let inherit (final) system; in {
					unstable = import unstable { inherit config system; };
					#helix-git = inputs.helix.packages.${system}.default;
					
					awesome-git-luajit = prev.awesome-git.override {
						lua = prev.luajit;
					};
				})
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
						inputs.nix-gaming.nixosModules.pipewireLowLatency
					];
				};
				snowflake = nixosSystem {
					system = "x86_64-linux";
					modules = shared-modules ++ [
						./hosts/snowflake.nix
					];
				};
			};
			snowstorm = self.nixosConfigurations.snowstorm.config.system.build.toplevel;
			snowflake = self.nixosConfigurations.snowflake.config.system.build.toplevel;
		};
	nixConfig = {
		substituters = [
			"https://cache.nixos.org?priority=10"
			"https://cache.ngi0.nixos.org/"
			"https://nix-community.cachix.org?priority=5"
			"https://nixpkgs-wayland.cachix.org"
			"https://fortuneteller2k.cachix.org"
			"https://nix-gaming.cachix.org"
		];
  	};
}
