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
			defaultSession = "hyprland";
			#session = [
			#	{
			#		manage = "desktop";
			#		name = "Polkit";
			#		start = ''
			#		exec dbus-launch --exit-with-session ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
			#		'';
			#	}
			#];
		};
	};
#	services.greetd = {
#		enable = true;
#		settings = {
#			default_session = {
#				command = ''
#				${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session --time --cmd Hyprland \
#					--sessions ${pkgs.river-git}/share/wayland-sessions
#				'';
#			};
#		};
#	};
#	environment.etc."greetd/environments".text = ''
#sway
#Hyprland
#	'';

	environment.systemPackages = with pkgs; [
		papirus-maia-icon-theme
		phinger-cursors
		orchis-theme
		libsForQt5.qtstyleplugins
		libsForQt5.qt5.qtgraphicaleffects
	];
	#qt5 = {
	#	enable = true;
	#	platformTheme = "gtk2";
	#	style = "gtk2";
	#};
	environment.etc = {
		"xdg/gtk-3.0/settings.ini" = {
			text = "${gtkconfig}";
			mode = "444";
		};
	};
}
