{ config, lib, pkgs, ... }:

with pkgs;
let
  	my-python-packages = python-packages: with python-packages; [
    		pandas
    		selenium
    		seaborn
    		python-lsp-server
    		keyring
    		tornado
    		requests
    		pynvim
    		pygobject3
		beautifulsoup4
    	];
	python-with-my-packages = python310.withPackages my-python-packages;
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
	nixpkgs.config.allowUnfree = true;
	nixpkgs.overlays = [
		(builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
 	];
	environment.systemPackages = with pkgs; [
	## developement
		python-with-my-packages
		git
		wget 
		neovim
		gobject-introspection

	## stuff needed for university
		yed
		gnuplot
		openconnect

	## day to day use
		libreoffice-still
		librewolf-wayland
		zathura
		unstable.thunderbird-bin
		gnome.geary #(i actually like that a lot)
		pdfarranger
		unstable.discord
		keepassxc
		
	## system utilities
		galculator
		pamixer
		blueman
		efibootmgr
		efitools
		pciutils
		usbutils
		smartmontools
		gparted
		xarchiver
		unzip
		virt-manager
		patchelf
		kdeconnect
		gammastep
		bpytop
		glow
		pcmanfm
		kitty
		pavucontrol
		playerctl
		brightnessctl
		tree

	## communication
		signal-desktop
		tdesktop #telegram

	## multimedia
		nomacs
		gimp
		inkscape
		spotify
		handbrake
		vlc
		xournalpp
		obs-studio

	## miscellaneous
		xorg.xev
		pfetch
		steam-run
		cowsay
		fortune
	];

	programs = {
		zsh.enable = true;
	};

	# for file managers
	services.gvfs.enable = true;

	fonts.fonts = with pkgs; [
		( nerdfonts.override { fonts = [ "CascadiaCode" ];} )
		lato
		inter
		cascadia-code
		material-design-icons
		#victor-mono #used as fallback for italic stuff
		twitter-color-emoji
	];

	
# systemd services for some stuff
	systemd = {
		user.services = {
			# basically copied the standard syncthing service file from Arch
			"syncthing" = {
				description = "Syncthing daemon";
				documentation = [ "man:syncthing" ];
				wantedBy = [ "default.target" ];
				# startlimitintervalsec = 60;
				# StartLimitBurst = 4;
				serviceConfig = {
				 ExecStart = "${pkgs.syncthing}/bin/syncthing serve --no-browser --no-restart --logflags=0";
				 Restart = "on-failure";
				 RestartSec = 1;
				 SuccessExitStatus = "3 4";
				 RestartForceExitStatus = "3 4";
				 SystemCallArchitecture = "native";
				 MemoryDenyWriteExecute = "true";
				 NoNewPriviliges = "true";
				};
			};
		};
	};
}
