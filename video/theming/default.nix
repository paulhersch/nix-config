{ config, pkgs, ... }:
let
	gtkconfig = ''
	 [Settings]
	 gtk-icon-theme-name=Papirus
	 gtk-theme-name=Orchis-green-dark
	 gtk-cursor-theme-size=16
	'';
in {
	services.xserver = {
		enable = true;
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
					theme = { package = pkgs.orchis-theme; name="Orchis-Dark"; };
					cursorTheme = { package = pkgs.phinger-cursors; name = "Phinger Cursors (light)"; };
					iconTheme = { package = pkgs.papirus-maia-icon-theme; name = "Papirus-Dark"; };
					indicators = [ "~session" "~spacer" ];
				};
			};
		};
#			sddm = {
#				enable = true;
#				theme = "sugar-dark";
#			};
	};

	environment.systemPackages = with pkgs; [
		papirus-maia-icon-theme
		phinger-cursors
		orchis-theme
	];
	environment.etc = {
		"xdg/gtk-3.0/settings.ini" = {
			text = "${gtkconfig}";
			mode = "444";
		};
	};
}
