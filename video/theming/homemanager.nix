{ config, lib, pkgs, ... }:
let
	theme = import ./colors.nix { };
in
{
  home-manager.useUserPackages = false; #i am gonna be the only one really using them anyways
  home-manager.useGlobalPkgs = true;
	
  home-manager.users.paul = {
	gtk = {
		enable = true;
		font.name = "Inter";
		iconTheme = {
			name = "Papirus-Dark-Maia";
			package = pkgs.papirus-maia-icon-theme;
		};
		theme = {
			name = "phocus";
			package = pkgs.phocus; #.override {
			#	colors = with theme; {
			#		base00 = "${bg}";
			#		base01 = "${lbg}";
			#		base02 = "${c0}";
			#		base03 = "${c8}";
			#		base04 = "${c8}";
			#		base05 = "${c15}";
			#		base06 = "${c15}";
			#		base07 = "${c7}";
			#		base08 = "${c7}";
			#		base09 = "${c1}";
			#		base0A = "${c11}";
			#		base0B = "${c2}";
			#		base0C = "${c12}";
			#		base0D = "${c4}";
			#		base0E = "${c5}";
			#		base0F = "${c9}";
			#	};
			#	primary = "${theme.bg}";
			#	secondary = "${theme.lbg}";
			#};
		};
	};
	programs = {
		home-manager.enable = true;
		exa = {
			enable = true;
			enableAliases = true;
		};
	};
	xresources.extraConfig = import ./xresources.nix { inherit theme; };
  };
}
