{ config, pkgs, ... }:

{
	imports = [ 
		./hardware-configuration.nix
		./systempackages.nix
		./ownPkgs/main.nix
		./home/main.nix
		./video/main.nix
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
		docker.enable	= true;
	};

	nix = {
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

	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.kernelParams = [ "pci=noaer" ];

	services = {
		flatpak.enable = true;
		upower.enable = true;
		openssh.enable = true;
		blueman.enable = true;
		teamviewer.enable = true;
		printing = {
			enable = true;
#			drivers = with pkgs; [ gutenprint gutenprintBin hplip samsung-unified-linux-driver splix brlaser ];
		};
	};

	networking = {
		networkmanager.enable = true;
		firewall = { #needed for kdeconnect
			allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
			allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
		};
	};
	hardware.bluetooth = {
		enable = true;
		package = pkgs.bluezFull;
	};

	time.timeZone = "Europe/Berlin";

	i18n.defaultLocale = "de_DE.UTF-8";
	console = {
		keyMap = "de-latin1";
	};

	hardware.pulseaudio.enable = false;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
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
	config.pipewire-pulse = {
		"context.properties" = {
			"log.level" = 2;
    		};
    		"context.modules" = [
      		{
        		name = "libpipewire-module-rtkit";
        		args = {
          			"nice.level" = -15;
         			"rt.prio" = 88;
          			"rt.time.soft" = 200000;
          			"rt.time.hard" = 200000;
        			};
        		flags = [ "ifexists" "nofail" ];
      		}
      		{ name = "libpipewire-module-protocol-native"; }
      		{ name = "libpipewire-module-client-node"; }
      		{ name = "libpipewire-module-adapter"; }
      		{ name = "libpipewire-module-metadata"; }
      		{
        		name = "libpipewire-module-protocol-pulse";
        		args = {
          			"pulse.min.req" = "32/48000";
          			"pulse.default.req" = "32/48000";
          			"pulse.max.req" = "32/48000";
          			"pulse.min.quantum" = "32/48000";
          			"pulse.max.quantum" = "32/48000";
          			"server.address" = [ "unix:native" ];
        		};
      		}
    		];
    		"stream.properties" = {
      		"node.latency" = "32/48000";
      		"resample.quality" = 1;
    		};
  	};
  	}; #too lazy to properly indent this ready made config to the overall style in here

#	programs.gnupg.agent = {
#		enable = true;
#		enableSSHSupport = true;
#	};

	system.stateVersion = "21.05";
} 
