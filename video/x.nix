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
		windowManager.awesome = {
			enable = true;
			package = pkgs.awesome-git;
			luaModules = with pkgs.luajitPackages; [
				lua
				lgi
				ldbus
			];
		};
    	};
	hardware.opengl.enable = true;

	# minimalistic gnome with good extensions as backup (no k-bloat)
	services.gnome.core-utilities.enable = false;
	environment.systemPackages = extensions ++ extrapkgs;
}
