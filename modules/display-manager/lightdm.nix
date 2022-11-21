{ config, pkgs, ... }:

{
	services.xserver = {
		enable = true;
		# this should be somewhere else to minimize confusion, but i am not gonna have an x.nix with 5 lines
		layout = "de";
		libinput = {
			enable = true;
		};
		displayManager = {
			lightdm = {
				enable = true;
				background = ./ldmbg.png;
				greeters.gtk = {
					enable = true;
					theme = {
						package = pkgs.orchis-theme;
						name="Orchis-Dark";
					};
					cursorTheme = {
						package = pkgs.phinger-cursors;
						name = "Phinger Cursors (light)";
					};
					iconTheme = {
						package = pkgs.papirus-maia-icon-theme;
						name = "Papirus-Dark";
					};
					indicators = [ "~session" "~spacer" ];
				};
			};
		};
	};
}
