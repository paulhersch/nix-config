{ pkgs, ... }:

{
	users.users = {
  		paul = {
  			createHome = true;
  			description = "Paul Schneider";
			isNormalUser = true;
   			extraGroups = [ "messagebus" "networkmanager" "flatpak" "libvirtd" "video" "docker" ];
			shell = pkgs.zsh;
  		};
		luise = {
			createHome = true;
			description = "Luise Haase";
			isNormalUser = true;
			extraGroups = [ "video" "networkmanager" "flatpak" "libvirtd" "messagebus" ];
		};
	};
}

