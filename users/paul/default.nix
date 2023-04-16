{ config, lib, pkgs, stdenv, ... }:
let
	theme = import ../../globals/colors.nix { };
	pylsp = [(pkgs.python310.withPackages (p: with p; [
		python-lsp-server
		flake8
	]))];
in
{
	imports = [
		./services/mopidy.nix
	];
	users.users.paul = {
  		createHome = true;
  		description = "Paul Schneider";
		isNormalUser = true;
   		extraGroups = [
			"messagebus"
			"networkmanager"
			"libvirtd"
			"video"
			"input"
			"docker"
			"plugdev"
		];
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
			#wezterm-git
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
					"wide glyphs"
					"vertcenter"
				];
				conf = import ./confs/config.def.h.nix {};
				#harfbuzzFeatures = [ "ss01" "ss02" "calt" "ss19" ];
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
			
			ripgrep
			fd
			
			# language servers
			texlab
			ltex-ls
			jdt-language-server
			java-language-server
			haskell-language-server
			sumneko-lua-language-server
			omnisharp-roslyn
			rnix-lsp
			# debuggers
			netcoredbg

		] ++ pylsp;
  	};
	home-manager.users.paul = {
		home = { stateVersion = "22.05"; };
		nixpkgs.config.allowUnfree = true;
		
		gtk = import ./gtk.nix { inherit pkgs; };
		xresources.extraConfig = import ./confs/xresources.nix { inherit theme; };
		
		home.file = {
			".config/wezterm/wezterm.lua".text = import ./confs/wez.nix { inherit theme; };
			".config/sway/config".text = import ./confs/sway/config.nix { inherit pkgs; inherit theme; };
		};

		# for direnv
		home.file.".zshrc".text = "eval \"$(direnv hook zsh)\"";
		programs = {
			direnv = {
				enable = true;
				nix-direnv.enable = true;
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
			alacritty = {
				enable = true;
				settings = {
					window = { 
						padding = {
							x = 5;
							y = 5;
						};
						dynamic_padding = true;
						decorations = "none";
					};
					scrolling = {
						history = 20000;
						multiplier = 5;
					};
					font = {
						normal = { family = "Iosevka Comfy Motion"; };
						size = 10.5;
						offset = { y = 2; };
						builtin_box_drawing = true;
					};
					selection = {
						save_to_clipboard = true;
					};
					cursor = {
						style = {
							shape = "beam";
							blinking = "on";
						};
						thickness = 0.1;
					};
					ipc_socket = false;
					mouse = { hide_when_typing = true; };
				};
			};
			foot = {
				enable = true;
				server.enable = true;
				settings = {
					main = {
						term = "xterm-256color";
						font = "Iosevka Comfy Motion:size=10.5, Symbols Nerd Font:size=10.5";
						pad = "10x10";
						dpi-aware = "yes";
					};
					tweak = {
						overflowing-glyphs = "yes";
					};
					bell = {
						urgent = "no";
						notify = "no";
					};
					scrollback = {
						lines = 10000;
					};
					cursor = {
						style = "beam";
						blink = "yes";
					};
					colors = with theme; {
						foreground = "${fg}";
						background = "${bg}";
						selection-background = "${llbg}";
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
					};
				};
			};
		};
		services = {
			mako = {
				enable = true;
				anchor = "bottom-right";
				font = "Recursive Sn Csl St 12";
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
