{ config, pkgs, ... }:

{
	imports = [ 
		#./hardware-configuration.nix
		./users
		./core
		./modules/x11/awesome.nix
		#./modules/wayland/hyprland.nix
		./modules/wayland/sway.nix
		#./modules/display-manager/lightdm
		./modules/display-manager/greetd
	];
	services.xserver.displayManager.gtkgreet = {
		enable = true;
		entries = [
			{
				entryName = "sway";
				isXWM = false;
				cmd = "${pkgs.sway}/bin/sway";
				postCmd = "dbus-launch ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
			}
		];
	};
	
	zramSwap = {
		enable = true;
		memoryPercent = 33;
	};

	boot = {
		initrd.systemd.enable = true;
		plymouth = {
			theme = "splash";
			themePackages = [(
				pkgs.unstable.adi1090x-plymouth-themes.override {
					selected_themes = ["splash"];
			})];
			enable = true;
		};
  		loader = { 
			efi = {
				canTouchEfiVariables = true;
			};
  			grub = {
 				enable = true;
				device = "nodev";
				efiSupport = true;
				efiInstallAsRemovable = false;
				configurationLimit = 5;
				enableCryptodisk = true;
  			};
		};
		supportedFilesystems = [ "ntfs" ];
	};

	time.timeZone = "Europe/Berlin";

	i18n.defaultLocale = "de_DE.UTF-8";
	
	services.xserver.xkbOptions = "caps:escape";
	console.useXkbConfig = true;
	
	# TODO: this should be done in mime settings
	environment.extraInit = ''
		export GI_TYPELIB_PATH="/run/current-system/sw/lib/girepository-1.0"
		export AWM_LIB_PATH="${pkgs.awesome-git}/share/awesome/lib/"
		export DEFAULT_BROWSER="${pkgs.librewolf}/bin/librewolf"
		export BROWSER="${pkgs.librewolf}/bin/librewolf"
	'';
	
	powerManagement.enable = true;

	system.stateVersion = "22.11";
} 
