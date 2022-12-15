{ config, pkgs, ...}:
{
	imports = [
		./x11defaults.nix
	];
	services.xserver.windowManager.awesome = {
		enable = true;
		package = pkgs.awesome-git;
		luaModules = with pkgs.luaPackages; [
			lgi
			ldbus
		];
	};
	environment.systemPackages = with pkgs; [
		xsel
		maim
		xfce.xfce4-clipman-plugin
		networkmanagerapplet
		rofi
		picom
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
