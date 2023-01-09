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
		picom
		libnotify
		lxrandr
		redshift
		i3lock-color
		sox
		cinnamon.nemo
		pamixer
		wezterm-git
	];
}
