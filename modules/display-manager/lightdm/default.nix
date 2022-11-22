{ config, pkgs, ... }:

{
	services.xserver = {
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
