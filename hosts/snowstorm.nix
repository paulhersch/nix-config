{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/display-manager/regreet
    # ../modules/x11/awesome.nix
    ../modules/wayland/sway.nix
    # ../modules/wayland/hyprland.nix
    ../modules/wayland/niri.nix
    ./common-real.nix
  ];

  # services.uni.jupyter.enable = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.kernelModules = [ "kvm-intel" "nvidia-uvm" ];
  boot.extraModulePackages = [ config.hardware.nvidia.package ];

  services.udev.packages = [ pkgs.via ];

  # Noita mod for coop
  environment.systemPackages =
    let
      steam-run = pkgs.steam-run;
      stdenvNoCC = pkgs.stdenvNoCC;
      makeWrapper = pkgs.makeWrapper;
    in
    [
      pkgs.via
      # https://github.com/NixOS/nixpkgs/pull/365769/commits/baeba6e0bd558185f475b5a02f007bfa06b25df1
      (stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "noita_entangled_worlds";
        version = "1.6.2";

        src = pkgs.fetchzip {
          url = "https://github.com/IntQuant/noita_entangled_worlds/releases/download/v${finalAttrs.version}/noita-proxy-linux.zip";
          hash = "sha256-08+W4uGTzVrnX4tsnoLFwvEuLPozdJbKAJZQJoqjXBA=";
          stripRoot = false;
        };

        nativeBuildInputs = [
          makeWrapper
        ];

        buildInputs = [
          steam-run
        ];

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          mkdir -p $out/libexec
          cp noita_proxy.x86_64 $out/libexec/noita-proxy-bin
          cp libsteam_api.so $out/libexec/
          # Create a wrapper script that calls the binary from libexec
          makeWrapper ${steam-run}/bin/steam-run $out/bin/noita-proxy \
          --add-flags "$out/libexec/noita-proxy-bin"
          runHook postInstall
        '';

        meta = {
          changelog = "https://github.com/IntQuant/noita_entangled_worlds/releases/tag/v${finalAttrs.version}";
          description = "True coop multiplayer mod for Noita";
          homepage = "https://github.com/IntQuant/noita_entangled_worlds";
          license = with lib.licenses; [
            asl20
            mit
          ];
          maintainers = with lib.maintainers; [ orbsa ];
          platforms = lib.platforms.linux;
          mainProgram = "noita-proxy";
        };
      }))
    ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/0a97ed09-58ce-4ab6-91d7-d7bdcb046d69";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" ];
    };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "weekly";
  };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/0a97ed09-58ce-4ab6-91d7-d7bdcb046d69";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/home/paul/Dokumente" =
    {
      device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=dokumente" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/Musik" =
    {
      device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=musik" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/Bilder" =
    {
      device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=bilder" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/Downloads" =
    {
      device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=downloads" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/Videos" =
    {
      device = "/dev/disk/by-uuid/e4b576ea-4882-4ec8-bb27-c1cd7f304c2d";
      fsType = "btrfs";
      options = [ "subvol=videos" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/.SteamLib" =
    {
      device = "/dev/disk/by-label/steamlibrary";
      fsType = "btrfs";
      options = [ "subvol=SteamLibrary" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/home/paul/.Games" =
    {
      device = "/dev/disk/by-label/steamlibrary";
      fsType = "btrfs";
      options = [ "subvol=Games" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/boot/EFI" =
    {
      device = "/dev/disk/by-uuid/04C1-533A";
      fsType = "vfat";
    };

  # i shouldn't have to blacklist the module in theory
  # boot.kernelParams = [ "module_blacklist=i915" ]; # "pci=noaer" ];
  swapDevices = [ ];

  services.xserver = {
    xkb.layout = "eu";
    videoDrivers = [ "nvidia" ];
  };

  boot.loader = {
    efi.efiSysMountPoint = "/boot/EFI";

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = false;
      configurationLimit = 5;
      enableCryptodisk = true;
    };
  };
  boot.kernelPackages = pkgs.linuxPackages;
  hardware = {
    # xone.enable = true;
    nvidia-container-toolkit.enable = true;
    nvidia = {
      # forceFullCompositionPipeline = true;
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
      };
    };
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
  };
  networking.hostName = "snowstorm";
}
