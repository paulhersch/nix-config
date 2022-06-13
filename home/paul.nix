{ config, lib, pkgs, ... }:
let
	theme = import ../video/theming/colors.nix { };
in
{
	users.users.paul = {
  		createHome = true;
  		description = "Paul Schneider";
		isNormalUser = true;
   		extraGroups = [ "messagebus" "networkmanager" "flatpak" "libvirtd" "video" "input" ];
		shell = pkgs.zsh;
		packages = with pkgs;[
			nodejs
			nodePackages.yarn
			dotnet-sdk
			dotnet-runtime
			geckodriver
			jetbrains.idea-community
			jetbrains.pycharm-community
			jetbrains.jdk
			jetbrains.rider
			ghc
			rustup
			gcc
			cargo
			haskell-language-server
			sumneko-lua-language-server
			omnisharp-roslyn
			vscodium-fhs
		];
  	};
	home-manager.users.paul = {
		gtk = {
			enable = true;
			font = {
				name = "Inter";
				size = 12;	
			};
			iconTheme = {
				name = "Papirus-Dark-Maia";
				package = pkgs.papirus-maia-icon-theme;
			};
			cursorTheme = {
				name = "Phinger Cursors (light)";
				package = pkgs.phinger-cursors;
				size = 24;
			};
			theme = {
				name = "phocus";
				package = pkgs.phocus.override {
					colors = with theme; {
						base00 = "${bg}";
						base01 = "${lbg}";
						base02 = "${lbg}"; #why does mozilla use this for fonts behind bg men
						base03 = "${c10}";
						base04 = "${c8}";
						base05 = "${c15}";
						base06 = "${c15}";
						base07 = "${c7}";
						base08 = "${c7}";
						base09 = "${c1}";
						base0A = "${c11}";
						base0B = "${c1}";
						base0C = "${c7}";
						base0D = "${fg}";
						base0E = "${c5}";
						base0F = "${c9}";
					};
					primary = "${theme.c2}";
					secondary = "${theme.c10}";
				};
			};
		};
		programs = {
			home-manager.enable = true;
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
						font = "CaskaydiaCove Nerd Font:size=8";
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
						bright0 = "${c0}";
						bright1 = "${c1}";
						bright2 = "${c2}";
						bright3 = "${c3}";
						bright4 = "${c4}";
						bright5 = "${c5}";
						bright6 = "${c6}";
						bright7 = "${c7}";
						selection-background = "${c7}";
					};
				};
			};
		};
		xresources.extraConfig = import ../video/theming/xresources.nix { inherit theme; };
  	};
}
