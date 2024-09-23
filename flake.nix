{
	description = "Flake for my Systems";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
        # neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
		ags.url = "github:Aylur/ags";
        astal-river.url = "github:astal-sh/river";
        libastal.url = "github:astal-sh/libastal";
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
                    astal = inputs.libastal.packages.${system}.default;
                    # inputs.libastal.packages.${default}.default;
                    astal-river = inputs.astal-river.packages.${system}.default;
                    libastal-lua = let
                        astal-lualib = prev.pkgs.luajitPackages.toLuaModule (
                            prev.pkgs.stdenv.mkDerivation {
                                name = "astal-lualib";
                                version = "0.1.0";
                                src = "${inputs.libastal}/lua";
                                dontBuild = true;
                                installPhase = ''
                                    mkdir -p $out/share/lua/${prev.pkgs.luajit.luaversion}/astal
                                    cp -r astal/* $out/share/lua/${prev.pkgs.luajit.luaversion}/astal
                                    '';
                            }
                        );
                        lua-env = prev.pkgs.luajit.withPackages (p:
                            [p.lgi p.fzy p.rapidjson astal-lualib]
                        );
                    in prev.pkgs.stdenv.mkDerivation {
                        pname = "astal-lua";
                        version = "0.1.0";
                        nativeBuildInputs = with prev.pkgs; [
                            gobject-introspection
                            wrapGAppsHook
                        ];
                        unpackPhase = "true";
                        buildInputs = with prev.pkgs; [
                            luajit
                            glib
                            inputs.libastal.packages.${system}.default
                            # should be included in the default libastal package
                            # inputs.astal-river.packages.${system}.default
                        ];
                        installPhase = ''
                            mkdir -p $out/bin
                            ln -s ${lua-env}/bin/lua $out/bin/libastal-lua
                        '';
                    };
					ags = inputs.ags.packages.${system}.default;
					unstable = import inputs.unstable { inherit config system; };
					gtk-materia-custom = prev.pkgs.callPackage ./pkgs/materia-custom.nix {};
				})
			];

			overlayed_nixpkgs = {
				nixpkgs = { inherit config overlays; };
			};
		in
		{
			nixosConfigurations = {
				snowstorm = nixosSystem {
					system = "x86_64-linux";
					modules = [overlayed_nixpkgs] ++ [
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
					modules = [overlayed_nixpkgs] ++ [
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
					modules = [overlayed_nixpkgs] ++ [
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
