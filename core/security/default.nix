{ config, ...}:

{
	imports = [
		#./firejail.nix
	];
	security = {
		sudo.enable = false;
		# caused weird issues with docker, so its disabled
		#lockKernelModules = true;
		protectKernelImage = true;
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
