{ config, lib, pkgs, discocss, stdenv, ... }:
let
	theme = import ../../video/theming/colors.nix { };
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
	users.users.paul = {
  		createHome = true;
  		description = "Paul Schneider";
		isNormalUser = true;
   		extraGroups = [ "messagebus" "networkmanager" "flatpak" "libvirtd" "video" "input" "docker" ];
		shell = pkgs.zsh;
		packages = with pkgs;[
			nodejs
			nodePackages.yarn
			dotnet-sdk
			dotnet-runtime
			geckodriver
			chromedriver
			chromium
			jetbrains.idea-community
			jetbrains.pycharm-community
			jetbrains.jdk
			jetbrains.rider

			(pkgs.callPackage ../../ownPkgs/st-flex.nix {
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
					"themed cursor"
					"undercurl"
					"wide glyphs"
				];
				conf = import ./config.def.h {};
				#harfbuzzFeatures = [ "ss01" "ss02" ];
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
		home = {
			stateVersion = "22.05";
		};
		nixpkgs.config.allowUnfree = true;
		imports = [ 
			(builtins.getFlake "github:mlvzk/discocss/flake").hmModule
		];
		
		home.file.".config/wezterm/wezterm.lua".text = import ./wez.nix { inherit theme; };
		xresources.extraConfig = import ../../video/theming/xresources.nix { inherit theme; };
		
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
				#name = "Everblush-gtk";
				#package = (pkgs.callPackage ../../ownPkgs/everblushgtk.nix {});
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
					gtk-enable-event-sounds=1
					gtk-enable-input-feedback-sounds=1
					gtk-xft-antialias=1
					gtk-xft-hinting=1
					gtk-xft-hintstyle="hintslight"
					gtk-xft-rgba="rgb"
				'';
			};
		};
		#services = {
		#	mopidy = {
		#		enable = true;
		#		extensionPackages = with pkgs; [
		#				mopidy-mpd
		#				mopidy-mpris
		#				mopidy-local
		#			];
		#		settings = {
		#			audio = {
		#				mixer_volume = 30;
		#			};
		#			
		#			mpd = {
		#				enabled = true;
		#				hostname = "127.0.0.1";
		#				port = 6600;
		#				max_connections = 20;
		#				connection_timeout = 60;
		#			};
		#	
		#			local = {
		#				enabled = true;
		#				media_dir = "/home/paul/Musik/Files/";
		#			};
		#			
		#			file = {
		#				media_dirs = [
		#					"/home/paul/Musik/Files/|Music"
		#				];
		#			};
		#			m3u = {
		#				enabled = true;
		#				playlists_dir = "/home/paul/Musik/Playlists/";
		#				base_dir = "/home/paul/Musik/Playlists/";
		#			};
		#	
		#			mpris = {
		#				enabled = true;
		#				bus_type = "session";
		#			};
		#		};
		#	};
		#};
		programs = {
			discocss = {
				enable = true;
				css = import ./discord_css.nix { inherit theme; };
			};
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
#						font = "Cascadia Code:size=8, CaskaydiaCove Nerd Font Mono:size=8";
#					};
#					cursor = {
#						blink = "yes";
#						style = "beam";
#					};
#					colors = with theme; {
#						foreground = "${fg}";
#						background = "${bg}";
#						regular0 = "${c0}";
##						regular1 = "${c1}";
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
}
