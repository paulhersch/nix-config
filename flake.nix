{
  description = "Flake for my Systems";

  inputs = {
    # for torzu, got taken down
    old.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    libastal.url = "github:Aylur/astal";
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    }@inputs:
      with nixpkgs.lib;
      let
        overlays = with inputs; [
          nixpkgs-f2k.overlays.default
          # inputs.neovim-nightly.overlays.default
          # copied this from ft2k, i guess this delays the eval of system until the attribute is set or smth
          (final: prev:
            let inherit (final) system; in {
              astal = inputs.libastal.packages.${system}.default;
              quickshell = inputs.quickshell.packages.${system}.default;
              # inputs.libastal.packages.${default}.default;
              libastal-lua =
                let
                  astal-lualib = prev.pkgs.luajitPackages.toLuaModule (
                    prev.pkgs.stdenv.mkDerivation {
                      name = "astal-lualib";
                      version = "0.1.0";
                      src = "${inputs.libastal}/lang/lua/astal";
                      dontBuild = true;
                      installPhase = ''
                        mkdir -p $out/share/lua/${prev.pkgs.luajit.luaversion}/astal
                        cp -r * $out/share/lua/${prev.pkgs.luajit.luaversion}/astal
                      '';
                    }
                  );
                  lua-env = prev.pkgs.luajit.withPackages (p:
                    [ p.lgi p.fzy p.rapidjson astal-lualib ]
                  );
                in
                prev.pkgs.stdenv.mkDerivation {
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
                    gtk3
                    inputs.libastal.packages.${system}.default
                    inputs.libastal.packages.${system}.astal3
                    inputs.libastal.packages.${system}.auth
                    inputs.libastal.packages.${system}.battery
                    inputs.libastal.packages.${system}.river
                    inputs.libastal.packages.${system}.tray
                    inputs.libastal.packages.${system}.notifd
                  ];
                  installPhase = ''
                    mkdir -p $out/bin
                    ln -s ${lua-env}/bin/lua $out/bin/libastal-lua
                  '';
                };
              unstable = import inputs.unstable { inherit system; config = { allowUnfree = true; }; };
              old = import inputs.old { inherit system; config = { allowUnfree = true; }; };
              gtk-materia-custom = prev.pkgs.callPackage ./pkgs/materia-custom.nix { };
            })
        ];

        default_nixpkgs = {
          nixpkgs = {
            inherit overlays;
            config = {
              allowUnfree = true;
            };
          };
        };

        forAllPkgs = f: genAttrs [ "x86_64-linux" ] (system:
          f (import nixpkgs { inherit system; })
        );
      in
      {
        formatter = forAllPkgs (pkgs: pkgs.nixpkgs-fmt);
        nixosConfigurations = {
          snowstorm = nixosSystem {
            system = "x86_64-linux";
            modules = [ default_nixpkgs ] ++ [
              ./configuration.nix
              ./hosts/snowstorm.nix
              ./nixsettings.nix
              ./modules/uni
              ./modules/gaming
              home-manager.nixosModules.home-manager
              { }
            ];
          };
          snowflake = nixosSystem {
            system = "x86_64-linux";
            modules = [ default_nixpkgs ] ++ [
              ./configuration.nix
              ./hosts/snowflake.nix
              ./nixsettings.nix
              ./modules/uni
              home-manager.nixosModules.home-manager
              { }
            ];
          };
          snowball = nixosSystem {
            system = "x86_64-linux";
            modules = [ default_nixpkgs ] ++ [
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
