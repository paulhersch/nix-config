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
					"netwmicon"
					"scrollback"
					"scrollback mouse"
					"scrollback mouse altscreen"
					#"sync"
					"undercurl"
					"wide glyphs"
				];
				conf = import ./config.def.h {};
				ligatures = true;
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

			## neovim deps
			xsel
			unstable.neovim
			texlab
			jdt-language-server
			haskell-language-server
			sumneko-lua-language-server
			omnisharp-roslyn
			ripgrep
			fd
		];
  	};
	home-manager.users.paul = {
		home.stateVersion = "22.05";
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
			home-manager.enable = true;
			discocss = {
				enable = true;
				css = import ./discord_css.nix { inherit theme; };
			};
			exa = {
				enable = true;
				enableAliases = true;
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
		#	ncmpcpp = {
		#		enable = true;
		#	};
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
			foot = {
				enable = true;
				server.enable = true;
				settings = {
					main = {
						font = "Cascadia Code:size=8, CaskaydiaCove Nerd Font Mono:size=8";
					};
					cursor = {
						blink = "yes";
						style = "beam";
					};
					colors = with theme; {
						foreground = "${fg}";
						background = "${bg}";
						regular0 = "${c0}";
						regular1 = "${c1}";
						regular2 = "${c2}";
						regular3 = "${c3}";
						regular4 = "${c4}";
						regular5 = "${c5}";
						regular6 = "${c6}";
						regular7 = "${c7}";
						
						bright0 = "${c8}";
						bright1 = "${c9}";
						bright2 = "${c10}";
						bright3 = "${c11}";
						bright4 = "${c12}";
						bright5 = "${c13}";
						bright6 = "${c14}";
						bright7 = "${c15}";
						selection-background = "${c7}";
					};
				};
			};
		#	kitty = {
		#		enable = true;
		#			#font_family		CaskaydiaCove Nerd Font
		#			#bold_font		auto
		#			#italic_font		Fantasque Sans Mono Nerd Font
		#			#bold_italic_font	auto
		#		settings.extraConfig = with theme; 
		#		''
		#			
		#			font_family		Cascadia Code
		#			italic_font		Victor Mono
		#			font_size		10
		#
		#			disable_ligatures	never
		#			enable_audio_bell 	no
		#			focus_follows_mouse	yes	
		#
		#			cursor_blink_interval	0
		#			cursor_shape		beam
		#			cursor_beam_thickness	0.8
		#
		#			scrollback_lines	4000
		#
		#			enabled_layouts		Splits
		#			map alt+v		launch --location=hsplit
		#			map alt+h		launch --location=vsplit
		#			map super+up 		neighboring_window up
		#			map super+down		neighboring_window down
		#			map super+left		neighboring_window left
		#			map super+right		neighboring_window right
		#			background		#${bg}
		#			foreground		#${fg}
		#			cursor			#${fg}
		#			selection_background	#${lbg}
		#			color0			#${c0}
		#			color1			#${c1}
		#			color2			#${c2}
		#			color3			#${c3}
		#			color4			#${c4}
		#			color5			#${c5}
		#			color6			#${c6}
		#			color7			#${c7}
		#			color8			#${c8}
		#			color9			#${c9}
		#			color10			#${c10}
		#			color11			#${c11}
		#			color12			#${c12}
		#			color13			#${c13}
		#			color14			#${c14}
		#			color15			#${c15}
		#		'';
		#	};
		};
  	};
}
