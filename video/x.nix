{ config, pkgs, ...}:
{
	services.xserver = {
		layout = "de";
		enable = true;
		libinput = {
			enable = true;
		};
	#	desktopManager.plasma5.enable = true;
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
		displayManager.defaultSession = "Polkit+LightLock+awesome"; #Polkit config thing in theming.nix (please don't question this)
    	};
	hardware.opengl.enable = true;

	# minimalistic gnome with good extensions as backup (no k-bloat)
	services.gnome.core-utilities.enable = false;
	environment.systemPackages = with pkgs.gnomeExtensions; [
		dash-to-panel
		blur-my-shell
		arcmenu
	];
}
