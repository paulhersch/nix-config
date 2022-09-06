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
  ];
  python-with-my-packages = python39.withPackages my-python-packages;
in
{
	nixpkgs.config.allowUnfree = true;
	nixpkgs.overlays = [
		(builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
		#(import (builtins.fetchTarball {
		#	url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
		#}))
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
		thunderbird-bin
		gnome.geary #(i actually like that a lot)
		pdfarranger
		discord
		
	## system utilities
		galculator
		pamixer
		blueman
		keepassxc
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
#		kdenlive
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
		( nerdfonts.override { fonts = [ "CascadiaCode" "FantasqueSansMono" "RobotoMono" ];} )
		lato
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
#			"mpdmpris" = {
#				description = "mpd-mpris bridge";
#				after = [ "mpd.service" ];
#				serviceConfig = {
#					ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris";
#					Restart = "on-failure";
#					RestartSec = 5;
#				};
#			};
		};
	};
}
