{
	description = "Flake for my Systems";
	
	inputs = {
		nixpkgs.url = github:nixos/nixpkgs/nixos-23.11;
		unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
		nixpkgs-f2k.url = github:fortuneteller2k/nixpkgs-f2k;
		home-manager = {
			url = github:nix-community/home-manager/release-23.11;
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-gaming.url = github:fufexan/nix-gaming;
	};

	outputs =
		{ self
		, nixpkgs
		, home-manager
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
					unstable = import inputs.unstable { inherit config system; };
					gtk-materia-custom = prev.pkgs.callPackage ./pkgs/materia-custom.nix {};
				})
			];

			overlayed_nixpkgs = [{
				nixpkgs = { inherit config overlays; };
			}];
		in
		{
			nixosConfigurations = {
				snowstorm = nixosSystem {
					system = "x86_64-linux";
					modules = overlayed_nixpkgs ++ [
						./configuration.nix
						./hosts/snowstorm.nix
						./nixsettings.nix
						./modules/uni
						./modules/gaming
						inputs.nix-gaming.nixosModules.pipewireLowLatency
						home-manager.nixosModules.home-manager {
						}
					];
				};
				snowflake = nixosSystem {
					system = "x86_64-linux";
					modules = overlayed_nixpkgs ++ [
						./configuration.nix
						./hosts/snowflake.nix
						./nixsettings.nix
						./modules/uni
						home-manager.nixosModules.home-manager {
						}
					];
				};
				snowball = nixosSystem {
					system = "x86_64-linux";
					modules = overlayed_nixpkgs ++ [
						./hosts/snowball
						./nixsettings.nix
					];
				};
			};
			snowstorm = self.nixosConfigurations.snowstorm.config.system.build.toplevel;
			snowflake = self.nixosConfigurations.snowflake.config.system.build.toplevel;
			snowball = self.nixosConfigurations.snowball.config.system.build.toplevel;
		};
}
