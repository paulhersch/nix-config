{ config, lib, pkgs, options, ...}:

let
	lua-stuff = import ../display-mixed/awm-lua-env.nix {
		inherit config lib pkgs options;
	};
	makeSearchPath = lib.concatMapStrings (path:
		" --search " + (lua-stuff.getLuaPath path "share") +
		" --search " + (lua-stuff.getLuaPath path "lib")
	);
	env-searchpath = makeSearchPath lua-stuff.modules;
    gtkgreet-enabled = builtins.hasAttr "gtkgreet" options.services.xserver.displayManager;
in
{
	imports = [
		./x11defaults.nix
	];
	# create configs for lightdm and own greeter (if imported)
	services.xserver.displayManager = {
		session = [{
			manage = "desktop";
			name = "awesomeWM";
			start = ''
				xrdb -load .Xresources
				autorandr -c
				${pkgs.awesome-luajit-git}/bin/awesome ${env-searchpath} 2> ~/.cache/awesome/stderr &
				waitPID=$!
				dbus-launch --exit-with-x11 ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
				dbus-launch --exit-with-x11 ${pkgs.lightlocker}/bin/light-locker &
			'';
		}];
	} // lib.optionalAttrs gtkgreet-enabled {
		gtkgreet.entries = [{
			entryName="awesome";
			isXWM = true;
			preCmd = ''
				xrdb -load .Xresources
				autorandr -c
			'';
			cmd = "${pkgs.awesome-git-luajit}/bin/awesome ${env-searchpath}";
			postCmd = "dbus-launch --exit-with-x11 ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
		}];
	};

	environment.systemPackages = with pkgs; [
		awesome-luajit-git #for awesome-client
		xsel
		xclip
		maim
		xfce.xfce4-clipman-plugin
		networkmanagerapplet
		picom
		libnotify
		lightlocker
		lxrandr
		redshift
		i3lock-color
		sox
		pamixer
		imagemagick
		pcmanfm
	];

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
		];
		# use wm/de name defined above
		config.awesomeWM = { default = [ "gtk" ];};
	};
}
