{ config, pkgs, ...}:
let
	extensions = with pkgs.gnomeExtensions; [
		dock-from-dash
		blur-my-shell
		tray-icons-reloaded
	];
	extrapkgs = with pkgs; [
		gnome.nautilus
		gnome3.gnome-tweaks
	];
in
{
	services.xserver = {
		windowManager = {
			session = pkgs.lib.singleton {
				name = "awesomeDEBUG";
				start = ''
					exec dbus-run-session -- ${pkgs.awesome-git}/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
				'';
			};
			awesome = {
				enable = true;
				package = pkgs.awesome-git;
				luaModules = with pkgs.luaPackages; [
					lgi
					ldbus
				];
			};
    		};
	};

	#for awesomewm
	environment.systemPackages = with pkgs; [
		feh
		xsel
		maim
		xfce.xfce4-clipman-plugin
		networkmanagerapplet
		rofi
		picom-git
		libnotify
		lxappearance
		lxrandr
		redshift
		i3lock-color
		autorandr
		sox
	];
}
