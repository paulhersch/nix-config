{ config, lib, pkgs, stdenv, ... }:
let
	theme = import ../../globals/colors.nix { };
in
{
	imports = [
		#./services/mopidy.nix
	];
	users.users.paul = {
  		createHome = true;
  		description = "Paul Schneider";
		isNormalUser = true;
   		extraGroups = [ "messagebus" "networkmanager" "libvirtd" "video" "input" "docker" "plugdev" ];
		shell = pkgs.zsh;
		packages = with pkgs;[
			steam-run
			nodejs
			nodePackages.yarn
			geckodriver
			chromedriver
			chromium
			jetbrains.idea-community
			jetbrains.pycharm-community
			jetbrains.jdk
			jetbrains.rider

			(pkgs.callPackage ../../pkgs/st-flex.nix {
				addPatches = [
					"anysize"
					"xresources"
					"boxdraw"
					"bold is not bright"
					"csi 22 23"
					"columns"
					"delkey"
					#"dynamic cursor color"
					"font2"
					"hidecursor"
					"ligatures"
					"netwmicon"
					"sixel"
					"scrollback"
					"scrollback mouse"
					"scrollback mouse altscreen"
					"sync"
					"themed cursor"
					"undercurl"
					#"wide glyphs"
					"vertcenter"
				];
				conf = import ./confs/config.def.h.nix {};
				harfbuzzFeatures = [ "ss01" "ss02" "calt" "ss19" ];
			})

			luaPackages.lua
			ghc
			rustup
			gcc
			gnumake
			cargo
			texlive.combined.scheme-full

			emacs
			## neovim + deps
			unstable.neovim
			texlab
			ltex-ls
			jdt-language-server
			java-language-server
			haskell-language-server
			sumneko-lua-language-server
			python310Packages.python-lsp-server
			nodePackages.pyright
			omnisharp-roslyn
			rnix-lsp
			#rubyPackages_3_1.solargraph
			ripgrep
			fd
			tym
		];
  	};
	home-manager.users.paul = {
		imports = [ 
#			(builtins.getFlake "github:mlvzk/discocss/flake").hmModule
		];

		home = {
			stateVersion = "22.05";
		};

		nixpkgs.config.allowUnfree = true;
		
		home.file.".config/wezterm/wezterm.lua".text = import ./confs/wez.nix { inherit theme; };
		xresources.extraConfig = import ./confs/xresources.nix { inherit theme; };

		gtk = {
			enable = true;
			font = {
				name = "Recursive Sn Lnr St";
				size = 11;
			};
			iconTheme = {
				name = "Papirus-Dark";
				package = pkgs.papirus-icon-theme;
			};
			cursorTheme = {
				name = "Phinger Cursors (light)";
				package = pkgs.phinger-cursors;
				size = 24;
			};
			theme = {
				name = "Materia-dark";
				package = pkgs.materia-theme;
			};
			gtk2 = {
				configLocation = "/home/paul/.gtkrc-2.0";
				extraConfig = ''
					include "/home/paul/.gtkrc-2.0.mine"
					gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
					gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
					gtk-button-images=0
					gtk-menu-images=0
					gtk-enable-event-sounds=0
					gtk-enable-input-feedback-sounds=0
					gtk-xft-antialias=1
					gtk-xft-hinting=1
					gtk-xft-hintstyle="hintslight"
					gtk-xft-rgba="rgb"
				'';
			};
		};
		# for direnv
		home.file.".zshrc".text = "eval \"$(direnv hook zsh)\"";
		programs = {
			direnv = {
				enable = true;
				nix-direnv.enable = true;
			};
#			discocss = {
#				css = import ./confs/discord_css.nix { inherit theme; };
#			};
			exa = {
				enable = true;
			};
			zathura = {
				enable = true;
				extraConfig = with theme;''
					set recolor
					set recolor-lightcolor "#${bg}"
					set recolor-darkcolor "#${fg}"
					set default-bg "#${bg}"
					set guioptions vhs
					set adjust-open width
				'';
			};
			mako = {
				enable = true;
				anchor = "bottom-right";
				font = "Inter Regular 11";
				borderRadius = 5;
				defaultTimeout = 5000;

				backgroundColor = "#${theme.bg}";
				textColor = "#${theme.fg}";
				borderColor = "#${theme.lbg}";
				progressColor = with theme; "over #${c2}";
			};
		};
  	};
}
