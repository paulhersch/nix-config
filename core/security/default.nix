{ config, pkgs, ...}:

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
			# samba browsing
			extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
		};
	};
	programs.ssh = {
		askPassword = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
		enableAskPassword = true;
	};
}
