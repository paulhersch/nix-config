{ config, ...}:

{
	imports = [
		#./firejail.nix
	];
	security = {
		sudo.enable = false;
		apparmor = {
			enable = true;
		};
	};
	networking = {
		networkmanager.enable = true;
		firewall = {
			enable = true;
			#needed for kdeconnect
			allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
			allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
		};
	};
}
