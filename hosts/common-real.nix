{ ... }:

# Options used on all my real machines, not for isos
{
  zramSwap = {
    enable = true;
    memoryPercent = 33;
    algorithm = "lz4";
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
    supportedFilesystems = { "ntfs" = true; };
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  services.xserver = {
    xkb.options = "caps:escape";
  };
  console.useXkbConfig = true;

  networking.extraHosts = ''
    127.0.0.1 mail.stegamail.de
  '';
}
