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
		layout = "de";
		enable = true;
		libinput = {
			enable = true;
		};
		desktopManager.gnome.enable = true;
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
				luaModules = with pkgs.luajitPackages; [
					lua
					lgi
					ldbus
				];
			};
    		};
	};
	
	environment.systemPackages = with pkgs; [
		maim
		xfce.xfce4-clipman-plugin
		networkmanagerapplet
		rofi
		picom
		libnotify
		lxappearance
		lxrandr
		redshift
	]

	# minimalistic gnome with good extensions as backup (no k-bloat)
	services.gnome.core-utilities.enable = false;
	environment.systemPackages = extensions ++ extrapkgs;
}
