{ config, pkgs, ...}:

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
	environment.systemPackages = with pkgs; [
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
		st
		cinnamon.nemo
		pamixer
	];
}
