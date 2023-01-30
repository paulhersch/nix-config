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
		supportedFilesystems = [ "ntfs" ];
	};

	nix = {
		package = pkgs.nixFlakes;
		settings = { #cachix 👍
			trusted-substituters = [
				"https://cache.nixos.org?priority=10"
				"https://nix-community.cachix.org?priority=5"
				"https://fortuneteller2k.cachix.org"
				"https://nix-gaming.cachix.org"
			];
			trusted-public-keys = [
				"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
				"fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
				"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
				"cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
				"nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
			];
			auto-optimise-store = true;
			experimental-features = [ "nix-command" "flakes" ];
		};
		extraOptions = ''
			keep-outputs = true
			keep-derivations = true
    		'';
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
