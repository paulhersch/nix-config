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
			wezterm-git
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
		home.file.".config/wezterm/wezterm.lua".text = import ./confs/wez.nix { inherit theme; };
		xresources.extraConfig = import ./confs/xresources.nix { inherit theme; };

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
		};
		services = {
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
