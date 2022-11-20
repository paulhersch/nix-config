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

	## day to day use
		libreoffice-still
		librewolf
		zathura
		unstable.thunderbird-bin
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
		gammastep
		bpytop
		pcmanfm
		cinnamon.nemo
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
		vlc
		xournalpp
		obs-studio

	## miscellaneous
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
	systemd.user.services."syncthing" = {
		description = "Syncthing daemon";
		documentation = [ "man:syncthing" ];
		# wantedBy = [ "default.target" ];
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
}
