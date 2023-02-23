{ config, lib, pkgs, modulesPath, home-manager, ... }:

{
  imports =
    [
    	(modulesPath + "/installer/scan/not-detected.nix")
	../modules/gaming
    ];

  #services.pipewire.lowLatency.enable = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0a97ed09-58ce-4ab6-91d7-d7bdcb046d69";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/0a97ed09-58ce-4ab6-91d7-d7bdcb046d69";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/home/paul/Dokumente" =
    { device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=dokumente" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/Musik" =
    { device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=musik" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/Bilder" =
    { device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=bilder" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/Downloads" =
    { device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=downloads" "compress=zstd:1" "relatime" ];
    };
 
  fileSystems."/home/paul/Videos" =
    { device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=videos" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/.SteamLib" =
    { device = "/dev/disk/by-label/steamlibrary";
      fsType = "btrfs";
      options = [ "subvol=SteamLibrary" "compress=zstd:1" "relatime" ];
    };
  
  fileSystems."/home/paul/.Games" =
    { device = "/dev/disk/by-label/steamlibrary";
      fsType = "btrfs";
      options = [ "subvol=Games" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/boot/EFI" =
    { device = "/dev/disk/by-uuid/04C1-533A";
      fsType = "vfat";
    };

  boot.kernelParams = [ "pci=noaer" ];
  swapDevices = [ ];
  services.xserver = {
  	videoDrivers = [ "amdgpu" ];
	# this appends as opposed to what docs say
	deviceSection = ''
  Option "VariableRefresh" "true"
	'';
  };
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware = {
	bluetooth = {
		enable = true;
		package = pkgs.bluezFull;
	};
  	cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  	opengl = {
		enable = true;
  		driSupport = true;
	};
  };
  services.autorandr = {
	enable = true;
	profiles = {
		"single" = {
			fingerprint = {
				DisplayPort-2 = "00ffffffffffff00220e8235000000001f1e0104a53c22783b8ce5a55850a0230b5054a54b00d1c0a9c081c0d100b30095008100a940565e00a0a0a029503020350055502100001a000000fd003090dfdf3c010a202020202020000000fc00485020323778710a2020202020000000ff00434e4b303331314652320a202001f0020316f149101f041303120211012309070783010000023a801871382d40582c450055502100001e023a80d072382d40102c458055502100001ee8e40050a0a067500820980455502100001a87bc0050a0a055500820780055502100001a4c6b0050a0a030500820280855502100001a000000000000000000000000000000b1";
			};
			config = {
				HDMI-A-0.enable = false;
				DisplayPort-0.enable = false;
				DisplayPort-1.enable = false;
				DisplayPort-2 = {
					enable = true;
					crtc = 0;
					primary = true;
					position = "0x0";
					mode = "2560x1440";
					rate = "143.86";
				};
			};
		};
	};
  };
  networking.hostName = "snowstorm";
}
