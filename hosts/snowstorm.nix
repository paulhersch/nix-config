{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        # ../modules/x11/awesome.nix
        # ../modules/display-manager/lightdm
        ../modules/display-manager/regreet
        ../modules/wayland/sway.nix
        ../modules/wayland/river.nix
    ];

    services.uni.jupyter.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
    boot.initrd.kernelModules = [ "nvidia" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];

    # programs.corectrl = {
    #     enable = true;
    #     gpuOverclock = {
    #         enable = true;
    #         ppfeaturemask = "0xffffffff";
    #     };
    # };
    # environment.systemPackages = with pkgs; [ corectrl ];

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
        xkb.layout = "eu";
        videoDrivers = [ "nvidia" ];
        # this appends as opposed to what docs say
        # deviceSection = ''
        #     Option "TearFree" "true"
        #     Option "VariableRefresh" "true"
        #     Option "EnablePageFlip" "true"
        #     '';
    };
    boot.loader.efi.efiSysMountPoint = "/boot/EFI";
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware = {
        nvidia = {
            # forceFullCompositionPipeline = true;
            modesetting.enable = true;
            open = false;
            nvidiaSettings = true;
            # package = config.boot.kernelPackages.nvidia_x11;
            prime = {
                sync.enable = true;
                nvidiaBusId = "PCI:1:0:0";
                intelBusId = "PCI:0:2:0";
            };
        };
        keyboard.qmk.enable = true;
        bluetooth = {
            enable = true;
            package = pkgs.bluez;
        };
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
            extraPackages = with pkgs; [
                # libv
                nvidia-vaapi-driver
                # libva-utils
                # rocm-opencl-icd
                # rocm-runtime
            ];
        };
    };
    powerManagement = {
        # cpuFreqGovernor = "powersave";
    };
    networking.hostName = "snowstorm";
    # networking.interfaces.enp6s0.useDHCP = true;
}
