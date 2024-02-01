{ config, pkgs, lib, ... }:

{
	imports = [ 
		./users
		./core
		./modules/x11/awesome.nix
		./modules/wayland/hyprland.nix
		# ./modules/wayland/sway.nix
		./modules/display-manager/lightdm
		# ./modules/display-manager/greetd
	];

	# if greeter module is imported use greeter, else lightdm will be activated
	services.xserver.displayManager = {} // lib.optionalAttrs (
		builtins.hasAttr "gtkgreet" config.services.xserver.displayManager) {
			gtkgreet.enable = true;
		};
	
	zramSwap = {
		enable = true;
		memoryPercent = 33;
	};

	services.logind = {
		lidSwitch = "hibernate";
		lidSwitchDocked = "ignore";
		lidSwitchExternalPower = "ignore";
	};

	boot = {
		initrd.systemd.enable = true;
		plymouth = {
			# theme = "splash";
			# themePackages = [
			#	(pkgs.unstable.adi1090x-plymouth-themes.override {
			#		selected_themes = ["splash"];
			#	})
			#];
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
	
	services.xserver = {
		xkbOptions = "caps:escape";
	};
	console.useXkbConfig = true;
	
	environment.extraInit = ''
		export GI_TYPELIB_PATH="/run/current-system/sw/lib/girepository-1.0"
		export AWM_LIB_PATH="${pkgs.awesome-git}/share/awesome/lib/"
	'';
	
	system.stateVersion = "22.11";
} 
