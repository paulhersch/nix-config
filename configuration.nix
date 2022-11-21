{ config, pkgs, ... }:

{
	imports = [ 
		./hardware-configuration.nix
		./users
		./core
		./modules/x11/awesome.nix
		./modules/display-manager/lightdm.nix
	];

	boot = {
		plymouth = {
			enable = true;
		};
  		loader = { 
			efi = {
				canTouchEfiVariables = true;
			};
  			grub = {
 				enable = true;
				version = 2;
				device = "nodev";
				efiSupport = true;
				efiInstallAsRemovable = false;
				configurationLimit = 5;
				enableCryptodisk = true;
  			};
		};
	};
  
	virtualisation = {
		libvirtd.enable = true;
		docker.rootless.enable = true;
	};

	nix = {
		autoOptimiseStore = true;
		package = pkgs.nixFlakes; #enables flakes
		extraOptions = ''
   			experimental-features = nix-command flakes 
		'';
		settings = { #cachix 👍
			substituters = [
				"https://cache.nixos.org?priority=10"
				"https://fortuneteller2k.cachix.org"
			];
			trusted-public-keys = [
				"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
				"fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
			];
		};
	};

	hardware = {
		bluetooth = {
			enable = true;
			package = pkgs.bluezFull;
		};
		opengl.enable = true;
	};
	time.timeZone = "Europe/Berlin";

	i18n.defaultLocale = "de_DE.UTF-8";
	
	services.xserver.xkbOptions = "caps:escape";
	console.useXkbConfig = true;

	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		pinentryFlavor = "curses";
	};

	environment.extraInit = ''
		export GI_TYPELIB_PATH="/run/current-system/sw/lib/girepository-1.0"
		export AWM_LIB_PATH="${pkgs.awesome-git}/share/awesome/lib/"
		export DEFAULT_BROWSER="${pkgs.librewolf}/bin/librewolf"
		export BROWSER="${pkgs.librewolf}/bin/librewolf"
	'';

	system.stateVersion = "22.05";
} 
