{ config, pkgs, ... }:

with pkgs;
let
  my-python-packages = python-packages: with python-packages; [
    pandas
    selenium
    seaborn
  ];
  luaPkgs = lua-pkgs: with lua-pkgs; [
    lgi
    lgdbus
    lua
  ];
  python-with-my-packages = python39.withPackages my-python-packages;

in
{
	nixpkgs.config.allowUnfree = true;
	nixpkgs.overlays = [
		(self: super: {
			neovim = super.neovim.override {
				viAlias = true;
				vimAlias = true;
     			};
   		})
		(builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlay
		(final: prev: {
			awesome-git = prev.awesome-git.overrideAttrs (old: rec {
				GI_TYPELIB_PATH = "${prev.networkmanager}/lib/girepository-1.0:" + old.GI_TYPELIB_PATH;
			});
		})
 	];
	environment.systemPackages = with pkgs; [
	## developement
		python-with-my-packages
		git
		wget 
		jetbrains.idea-community
		jetbrains.pycharm-community
		jetbrains.jdk #jetbrains.jdk has an extra C dependency, so i can still install java with nix-env without problems but use the runtimes from code-with-me
		ghc
		rustup
		gcc
		cargo

		haskell-language-server #for nvim coc modules
		sumneko-lua-language-server
		python-language-server
		luajit
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
		neovim
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
		zip
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

	programs.zsh.enable = true;
	services.gvfs.enable = true;

	fonts.fonts = with pkgs; [
		nerdfonts	
		inter
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
