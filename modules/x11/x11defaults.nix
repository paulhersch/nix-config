{ config, pkgs, ...}:

{
	services.xserver = {
		enable = true;
		exportConfiguration = true;
		layout = "de";
		libinput.enable = true;
	};
}
