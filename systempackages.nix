{ config, pkgs, ... }:

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
  ];
  python-with-my-packages = python39.withPackages my-python-packages;

in
{
	nixpkgs.config.allowUnfree = true;
	nixpkgs.overlays = [
		(self: super: {
			neovim-nightly = super.neovim-nightly.override {
				viAlias = true;
				vimAlias = true;
     			};
   		})
		(builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlay
		(import (builtins.fetchTarball {
			url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
		}))
 	];
	environment.systemPackages = with pkgs; [
	## developement
		python-with-my-packages
		git
		wget 
		luajit
		neovim-nightly
		wezterm-git

	## stuff needed for university
		yed
		gnuplot

	## extra stuff for work
		teamviewer
		openconnect
		geckodriver
	## day to day use
		librewolf-wayland 
		zathura
		thunderbird-bin
		libreoffice-still
		pdfarranger
		discord
		
	## system utilities
		at-spi2-core
		syncthing
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

	## awesomewm extra programs
		xfce.thunar
		xfce.thunar-volman
		xfce.thunar-archive-plugin
		xfce.thunar-media-tags-plugin
		gnome.gvfs
		maim
		brightnessctl
		pamixer
		playerctl
		xfce.xfce4-clipman-plugin
		mate.mate-polkit
		networkmanagerapplet
		rofi
		picom
		kitty
		libnotify
		lxappearance
		pavucontrol
		lxrandr
		redshift

	## communication
		signal-desktop
		tdesktop #telegram

	## multimedia
		nomacs
		blender
		gimp
		inkscape
		spotify
		handbrake
		vlc
		kdenlive
		audacity
		xournalpp

	## miscellaneous
		exa
		xorg.xev
		neofetch
		steam-run #has Ubuntu libraries, enables compatability for some programs
		cowsay
		fortune
		polymc
	];

	programs = {
		zsh.enable = true;
		steam.enable = true;
	};
	services.gvfs.enable = true;

	fonts.fonts = with pkgs; [
		nerdfonts	
		inter
		weather-icons
		material-icons
		powerline-fonts
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
				 ExecStart = "/run/current-system/sw/bin/syncthing serve --no-browser --no-restart --logflags=0";
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
