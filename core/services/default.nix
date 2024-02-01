{ pkgs, config, lib, ...}:

{
	imports = [
		./syncthing.nix
		./pipewire.nix
	];
	services = {
		upower.enable = true;
		openssh.enable = true;
		blueman.enable = true;
		gvfs = {
			enable = true;
			package = lib.mkForce pkgs.gnome.gvfs;
		};
		gnome = {
			gnome-keyring.enable = pkgs.lib.mkForce false;
		};
		printing = {
			enable = true;
			drivers = with pkgs; [ gutenprint gutenprintBin hplip samsung-unified-linux-driver splix brlaser cups-toshiba-estudio ];
		};
		xserver.modules = with pkgs; [ xf86_input_wacom ];
	};

	programs = {
		#thunar.enable = true;
		dconf.enable = true;
		system-config-printer.enable = true;
	};
	virtualisation = {
		libvirtd.enable = true;
		docker = {
			daemon.settings = {
				storage-driver = "overlay2";
			};
			enable = true;
			enableOnBoot = false;
		};
	};
}
