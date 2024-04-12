{ pkgs, ... }:

{
	imports = [ 
		./users
		./core
		# ./modules/x11/awesome.nix
        ./modules/wayland/sway.nix
		# ./modules/display-manager/lightdm
		./modules/display-manager/greetd
	];

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
	
	# environment.extraInit = ''
	# 	export GI_TYPELIB_PATH="/run/current-system/sw/lib/girepository-1.0"
	# 	export AWM_LIB_PATH="${pkgs.awesome-git}/share/awesome/lib/"
	# '';
	
	system.stateVersion = "22.11";
} 
