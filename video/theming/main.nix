{ config, pkgs, ... }:
let
	gtkconfig = ''
	 [Settings]
	 gtk-icon-theme-name=Papirus
	 gtk-theme-name=Orchis-green-dark
	 gtk-cursor-theme-size=36
	'';
in {
	imports = [
		./homemanager.nix
	];
	services.xserver.displayManager = {
		lightdm = {
			enable = true;
			greeters.enso = {
				enable = true;
				blur = true;
				cursorTheme = {
					name = "Phinger Cursors (light)";
					package = pkgs.phinger-cursors;
				};
				iconTheme = {
					name = "Papirus-Dark-Maia";
					package = pkgs.papirus-maia-icon-theme;
				};
				theme = {
					name = "Orchis-Green-Dark";
					package = pkgs.orchis-theme; 
				};
			};
		};
		session = [
			{
				manage = "desktop";
				name = "Polkit+LightLock";
				start = ''
				exec dbus-launch --exit-with-session ${pkgs.lightlocker}/bin/light-locker &
				exec dbus-launch --exit-with-session ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
				'';
			}
		];
	};
	services.xserver.windowManager = {
		session = pkgs.lib.singleton {
			name = "awesomeDEBUG";
			start = ''
				exec dbus-run-session -- ${pkgs.awesome-git}/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
			'';
		};
	};

	environment.systemPackages = with pkgs; [
		papirus-maia-icon-theme
		phinger-cursors
		orchis-theme
		libsForQt5.qtstyleplugins
	];
	#qt5 = {
	#	enable = true;
	#	platformTheme = "gtk2";
	#	style = "gtk2";
	#};
	#environment.etc = {
	#	"xdg/gtk-3.0/settings.ini" = {
	#		text = "${gtkconfig}";
	#		mode = "444";
	#	};
	#};
}
