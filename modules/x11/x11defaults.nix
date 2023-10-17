{ config, pkgs, ...}:

{
	services.xserver = {
		enable = true;
		exportConfiguration = true;
		libinput.enable = true;
	};
}
