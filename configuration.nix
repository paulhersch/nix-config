{ config, pkgs, ... }:

{
	imports = [ 
		./hardware-configuration.nix
		./systempackages.nix
		./ownPkgs
		./home
		./video
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

	programs.dconf.enable = true;
	programs.ssh.enableAskPassword = false;

	hardware.pulseaudio.enable = false;
	services = {
		upower.enable = true;
		openssh.enable = true;
#		pcscd.enable = true;
		blueman.enable = true;
#		teamviewer.enable = true;
		gnome = {
			gnome-keyring.enable = pkgs.lib.mkForce false;
		};
		printing = {
			enable = true;
			drivers = with pkgs; [ gutenprint gutenprintBin hplip samsung-unified-linux-driver splix brlaser ];
		};
		pipewire = {
			enable = true;
			alsa.enable = true;
			pulse.enable = true;
			media-session.config.bluez-monitor.rules = [
    				{
      					# Matches all cards
     					matches = [ { "device.name" = "~bluez_card.*"; } ];
      					actions = {
   						   	"update-props" = {
          						"bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          						# mSBC is not expected to work on all headset + adapter combinations.
          						"bluez5.msbc-support" = true;
          						# SBC-XQ is not expected to work on all headset + adapter combinations.
          						"bluez5.sbc-xq-support" = true;
        					};
      					};
    				}
    				{
      					matches = [
        					# Matches all sources
        					{ "node.name" = "~bluez_input.*"; }
        					# Matches all outputs
        					{ "node.name" = "~bluez_output.*"; }
      					];
      					actions = {
       						"node.pause-on-idle" = false;
     					};
    				}
  			];
		};
	};
	security.rtkit.enable = true;
	networking = {
		networkmanager.enable = true;
		firewall = { #needed for kdeconnect
			allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
			allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
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
	console = {
		keyMap = "de-latin1";
	};

	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		pinentryFlavor = "curses";
	};

	environment.extraInit = ''
		export GI_TYPELIB_PATH="/run/current-system/sw/lib/girepository-1.0"
		export AWM_LIB_PATH="${pkgs.awesome-git}/share/awesome/lib/"
	'';
	system.stateVersion = "22.05";
} 
