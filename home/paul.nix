{ config, lib, pkgs, ... }:
let
	theme = import ../video/theming/colors.nix { };
in
{
	users.users.paul = {
  		createHome = true;
  		description = "Paul Schneider";
		isNormalUser = true;
   		extraGroups = [ "messagebus" "networkmanager" "flatpak" "libvirtd" "video" ];
		shell = pkgs.zsh;
		packages = with pkgs;[
			nodejs
			nodePackages.yarn
		];
  	};
	home-manager.users.paul = {
		gtk = {
			enable = true;
			font.name = "Inter";
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
						base02 = "${lbg}";
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
				''; # this has to do until i find a way to properly use strings lol
			};
		};
		xresources.extraConfig = import ../video/theming/xresources.nix { inherit theme; };
  	};
}
