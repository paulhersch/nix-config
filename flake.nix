{
	description = "Flake for my Systems";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
		unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
		home-manager = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
        neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
		ags.url = "github:ozwaldorf/ags/feature/sway";
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
				nixpkgs-f2k.overlays.default
                # inputs.neovim-nightly.overlays.default
				# copied this from ft2k, i guess this delays the eval of system until the attribute is set or smth
				(final: prev: let inherit (final) system; in {
					ags = inputs.ags.packages.${system}.default;
					unstable = import inputs.unstable { inherit config system; };
					gtk-materia-custom = prev.pkgs.callPackage ./pkgs/materia-custom.nix {};
					# apparently doesnt override output like this :(
					gnvim = prev.gnvim.overrideAttrs (old: {
						version = "master";
						src = prev.pkgs.fetchFromGitHub {
							owner = "vhakulinen";
							repo = "gnvim";
							rev = "b8cc1bc78a94948041d37ddaf3d0ef05b45df40b";
							hash = "sha256-dQVHG7arUZJXDVNeqjjTqikK1TeEtwy3gY8ybgXqjy4=";
						};
					});
					# fail due to xdg directories being created in build.rs
					# pinnacle-comp = prev.pkgs.rustPlatform.buildRustPackage rec {
					# 	pname = "pinnacle-comp";
					# 	version = "dev";
					# 	src = prev.pkgs.fetchFromGitHub {
					# 		owner = "pinnacle-comp";
					# 		repo = "pinnacle";
					# 		rev = "7012b86a2deef195fc4562ded2699370189d01e5";
					# 		hash = "sha256-CYskHVV47JpMLoGbMW/3jTqUIqbOHRuMcbn28PXF/7M=";
					# 	};
					# 	cargoLock = {
					# 		lockFile = "${src}/Cargo.lock";
					# 		outputHashes = {
					# 			"smithay-0.3.0" = "sha256-IiHx7tqqANbZhz4EVjArcTj///lgd2ge2GFB66sZ3eM=";
					# 		};
					# 	};
					# 	preBuild = ''
					# 		export XDG_DATA_HOME=$out/share
					# 	'';
					# 	buildInputs = with prev.pkgs; [
					# 		(lua5_4.withPackages(lp: with lp; [
					# 			luarocks
					# 		]))
					# 		systemd.dev # libudev is in systemd
					# 		wayland
					# 		libxkbcommon
					# 		libinput
					# 		seatd
					# 		mesa
					# 		libglvnd
					# 		libGL.dev
					# 		egl-wayland
					# 		protobuf
					# 		xwayland
					# 		(with xorg; [
					# 			libX11
					# 			libXcursor
					# 			libXrandr
					# 		])
					#
					# 	];
					# 	nativeBuildInputs = buildInputs ++ (with prev.pkgs; [
					# 		pkg-config
					# 	]
                    # };
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
						#inputs.nix-gaming.nixosModules.pipewireLowLatency
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
