{ config, lib, pkgs, stdenv, ... }:
let
	theme = import ./confs/colors.nix { };
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
					"anysize simple"
					"xresources"
					"boxdraw"
					"bold is not bright"
					"csi 22 23"
					"columns"
					"delkey"
					"dynamic cursor color"
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
					"wide glyphs"
				];
				conf = import ./confs/config.def.h.nix {};
				harfbuzzFeatures = [ "ss01" "ss02" "calt" "ss19" ];
			})

			#docker-compose
			luaPackages.lua
			ghc
			rustup
			gcc
			cargo
			texlive.combined.scheme-full

			#unstable.wezterm

			## neovim + deps
			unstable.neovim
			xsel
			texlab
			ltex-ls
			jdt-language-server
			java-language-server
			haskell-language-server
			sumneko-lua-language-server
			omnisharp-roslyn
			ripgrep
			fd
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
				name = "Lato";
				size = 12;
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
#			mako = {
#				enable = true;
#				anchor = "bottom-right";
#				font = "Inter Regular 11";
#				borderRadius = 5;
#				defaultTimeout = 5000;
#
#				backgroundColor = "#${theme.bg}";
#				textColor = "#${theme.fg}";
#				borderColor = "#${theme.lbg}";
#				progressColor = with theme; "over #${c2}";
#			};
#			foot = {
#				enable = true;
#				server.enable = true;
#				settings = {
#					main = {
#						font = "Cascadia Code PL:size=6, CaskaydiaCove Nerd Font Mono:size=6";
#					};
#					cursor = {
#						blink = "yes";
#						style = "beam";
#					};
#					colors = with theme; {
#						foreground = "${fg}";
#						background = "${bg}";
#						regular0 = "${c0}";
#						regular1 = "${c1}";
#						regular2 = "${c2}";
#						regular3 = "${c3}";
#						regular4 = "${c4}";
#						regular5 = "${c5}";
#						regular6 = "${c6}";
#						regular7 = "${c7}";
#						
#						bright0 = "${c8}";
#						bright1 = "${c9}";
#						bright2 = "${c10}";
#						bright3 = "${c11}";
#						bright4 = "${c12}";
#						bright5 = "${c13}";
#						bright6 = "${c14}";
#						bright7 = "${c15}";
#						selection-background = "${c7}";
#					};
#				};
#			};
		};
  	};
}
