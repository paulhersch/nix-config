{ pkgs, config, ...}:

{
	imports = [
		./syncthing.nix
		./pipewire.nix
	];
	services = {
		upower.enable = true;
		openssh.enable = true;
		blueman.enable = true;
		gvfs.enable = true;
		teamviewer.enable = true;
		gnome = {
			gnome-keyring.enable = pkgs.lib.mkForce false;
		};
		printing = {
			enable = true;
			drivers = with pkgs; [ gutenprint gutenprintBin hplip samsung-unified-linux-driver splix brlaser ];
		};
	};

	programs.dconf.enable = true;
	programs.ssh.enableAskPassword = false;
	virtualisation = {
		libvirtd.enable = true;
		docker.enable = true;
	};
}
