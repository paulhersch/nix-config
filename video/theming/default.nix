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
			sddm = {
				enable = true;
				theme = "sugar-dark";
			};
		# shit doesnt fucking work
		#	session = [
		#		{
		#			manage = "desktop";
		#			name = "Polkit";
		#			start = ''
		#			exec dbus-launch --exit-with-session ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
		#			'';
		#		}
		#	];
		};
	};

	environment.systemPackages = with pkgs; [
		papirus-maia-icon-theme
		phinger-cursors
		orchis-theme
		libsForQt5.qtstyleplugins
		libsForQt5.qt5.qtgraphicaleffects
		(pkgs.callPackage ../../ownPkgs/sddm-sugar-dark.nix {})
	];
	environment.etc = {
		"xdg/gtk-3.0/settings.ini" = {
			text = "${gtkconfig}";
			mode = "444";
		};
	};
}
