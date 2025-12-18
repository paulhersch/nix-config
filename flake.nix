{
  description = "Flake for my Systems";

  inputs = {
    # for torzu, got taken down
    old.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    libastal.url = "github:Aylur/astal";
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    with nixpkgs.lib;
    let
      overlays = with inputs; [
        nixpkgs-f2k.overlays.default
        # inputs.neovim-nightly.overlays.default
        # copied this from ft2k, i guess this delays the eval of system until the attribute is set or smth
        (
          final: prev:
          let
            system = prev.pkgs.stdenv.hostPlatform.system;
          in
          {
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
                lua-env = prev.pkgs.luajit.withPackages (p: [
                  p.lgi
                  p.fzy
                  p.rapidjson
                  astal-lualib
                ]);
              in
              prev.pkgs.stdenv.mkDerivation {
                pname = "astal-lua";
                version = "0.1.0";
                nativeBuildInputs = with prev.pkgs; [
                  gobject-introspection
                  wrapGAppsHook3
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
            unstable = import inputs.unstable {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
            old = import inputs.old {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
            gtk-custom = prev.pkgs.callPackage ./pkgs/qogir-custom.nix {
              theme-name = "Custom";
              color-variant = "light";
              color-changes = (
                let
                  colors = import ./globals/colors.nix { };
                in
                rec {
                  alt_dark_sidebar_fg = "#${colors.fg}";
                  base_color = "#${colors.bg}";
                  bg_color = "#${colors.bg}";
                  dark_sidebar_bg = "#${colors.dbg}";
                  dark_sidebar_fg = "#${colors.fg}";
                  dark_sidebar_icon_bg = dark_sidebar_bg;
                  dark_sidebar_icon_fg = dark_sidebar_fg;
                  destructive_color = error_color;
                  destructive_fg_color = error_fg_color;
                  drop_target_color = "#${colors.dbg}";
                  error_color = "mix($bg_color, #${colors.c9}, \\$weight: 80%)";
                  error_fg_color = "#${colors.fg}";
                  fg_color = "#${colors.c7}";
                  header_bg_backdrop = dark_sidebar_bg;
                  header_bg = "#${colors.dbg}";
                  osd_bg_color = "#${colors.bg}";
                  osd_fg_color = "#${colors.fg}";
                  panel_bg = "#${colors.bg}";
                  selected_bg_color = "mix($bg_color, #${colors.c12}, \\$weight: 60%)";
                  selected_fg_color = "#${colors.fg}";
                  success_color = "mix($bg_color, #${colors.c10}, \\$weight: 80%)";
                  suggested_fg_color = selected_fg_color;
                  text_color = "#${colors.fg}";
                  warning_color = "mix($bg_color, #${colors.c11}, \\$weight: 80%)";
                  warning_fg_color = "#${colors.fg}";
                }
              );
            };
          }
        )
      ];

      default_nixpkgs = {
        nixpkgs = {
          inherit overlays;
          config = {
            allowUnfree = true;
          };
        };
      };

      forAllPkgs = f: genAttrs [ "x86_64-linux" ] (system: f (import nixpkgs { inherit system; }));
    in
    {
      formatter = forAllPkgs (pkgs: pkgs.nixpkgs-fmt);
      nixosConfigurations = {
        isox86 = nixosSystem {
          system = "x86_64-linux";
          modules = [
            default_nixpkgs
          ]
          ++ [
            ./hosts/iso
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
          ];
        };
        snowstorm = nixosSystem {
          system = "x86_64-linux";
          modules = [
            default_nixpkgs
          ]
          ++ [
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
          modules = [
            default_nixpkgs
          ]
          ++ [
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
          modules = [
            default_nixpkgs
          ]
          ++ [
            ./hosts/snowball
            ./nixsettings.nix
          ];
        };
      };
      snowstorm = self.nixosConfigurations.snowstorm.config.system.build.toplevel;
      snowflake = self.nixosConfigurations.snowflake.config.system.build.toplevel;
      snowball = self.nixosConfigurations.snowball.config.system.build.toplevel;
      isox86 = self.nixosConfigurations.isox86.config.system.build.isoImage;
    };
}
