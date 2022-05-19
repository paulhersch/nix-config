{ pkgs, ... }:

{
	users.users.luise = {
		createHome = true;
		description = "Luise Haase";
		isNormalUser = true;
		extraGroups = [ "video" "networkmanager" "flatpak" "libvirtd" "messagebus" ];
		};
	};
}

