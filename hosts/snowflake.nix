{ config, lib, pkgs, modulesPath, ... }:

{
  services = {
    uni.jupyter.enable = true;
    xserver.xkb.layout = "de";
  };
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/wayland/sway.nix
    # ../modules/wayland/river.nix
    # ../modules/wayland/niri.nix
    ../modules/display-manager/regreet
  ];
  networking.hostName = "snowflake";

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "cryptd" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "resume=UUID=6913a5e4-7c10-4a61-9fe9-d5b759e5c16e" ];
    loader = {
      efi.efiSysMountPoint = "/boot";
    };
  };

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      		  Option "TearFree" "true"
      		'';
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/addcd413-7635-48ae-b091-4892545a0a5c";
    fsType = "btrfs";
    options = [ "subvol=nixos" "compress=zstd" "noatime" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "weekly";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/addcd413-7635-48ae-b091-4892545a0a5c";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/168C-833A";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/6913a5e4-7c10-4a61-9fe9-d5b759e5c16e"; }
  ];

  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-uuid/9dc22222-57ab-4519-aca6-4bfc9a1e90c7";
    preLVM = true;
  };

  hardware = {
    enableAllFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libva
        libva-utils
      ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };
}
