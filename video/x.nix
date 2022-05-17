{ config, pkgs, ...}:
{
	services.xserver = {
		layout = "de";
		enable = true;
		libinput = {
			enable = true;
		};
		desktopManager.plasma5.enable = true;
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
}
