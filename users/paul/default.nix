{ config
, lib
, pkgs
, stdenv
, home-manager
, ...
}:
let
	theme = import ../../globals/colors.nix { };
	py_pkgs = (pkgs.python3.withPackages (p: with p; [
		python-lsp-server
		python-lsp-ruff
		python-lsp-black
		pylsp-mypy
		jupytext
		rope
	]));
in
{
	imports = [
		#./services/mopidy.nix
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
			"wheel" # for cups
		];
		shell = pkgs.zsh; # hilbish;
		packages = with pkgs;[
			qmk
			chromium
			firefox
			steam-run
            element-desktop
			(pkgs.callPackage ../../pkgs/st-flex.nix {
				addPatches = [
					"anysize"
					"xresources"
					"boxdraw"
					"bold is not bright"
					"csi 22 23"
					"columns"
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
				harfbuzzFeatures = [ "dlig" ];
			})

			luaPackages.lua
			ghc
			rustup
			gcc
			gnumake
			cargo
			texlive.combined.scheme-full
			anydesk
			pdfpc

			jetbrains.idea-community
			dbeaver
			# prismlauncher
			# openjdk
			# maven
			# psqlcli
			# postgresql_15

			## neovim + deps
			unstable.neovim
			unstable.neovide
			zk
			ripgrep
			fd
			# fucking Jupyter Notebooks
			# vscodium
            figma-linux
			
			# language servers
			texlab
			ltex-ls
			haskell-language-server
			sumneko-lua-language-server
			omnisharp-roslyn
			quick-lint-js
			nodePackages.typescript-language-server
			nodePackages.bash-language-server
			shellcheck
			nil
			ccls
			py_pkgs
			# debuggers
			gdb

			# annoying ass work software
			# citrix_workspace
			remmina
		];
  	};
	home-manager.users.paul = {
		home = { stateVersion = "22.05"; };
		nixpkgs.config.allowUnfree = true;
		
		gtk = import ./gtk.nix { inherit pkgs; };
		xresources.extraConfig = import ./confs/xresources.nix { inherit theme; };
		
		home.file = {
			".config/wezterm/wezterm.lua".text = import ./confs/wez.nix { inherit theme; };
			".config/alacritty/alacritty.yml".text = import ./confs/alacritty.nix { inherit theme; };
			".config/sway/config".text = import ./confs/sway/config.nix { inherit pkgs; inherit theme; };
			".config/fontconfig/conf.d/99-alias-main.conf".text = import ./confs/fontconf.nix {};
			".zshrc".text = ''
				eval "$(direnv hook zsh)"
				export ZK_NOTEBOOK_DIR=$HOME/Dokumente/Uni/zk
			'';
		};

		programs = {
			autorandr = import ./autorandrhm.nix {};
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
			alacritty.enable = true;
			foot = {
				enable = true;
				server.enable = true;
				settings = {
					main = {
						term = "xterm-256color";
						font = "Iosevka With Fallback:size=12";
						pad = "10x10";
						dpi-aware = "no";
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
