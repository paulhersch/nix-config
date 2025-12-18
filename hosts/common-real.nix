{ ... }:

# Options used on all my real machines, not for isos
{
  zramSwap = {
    enable = true;
    memoryPercent = 33;
    algorithm = "lz4";
  };

  services.logind.settings.Login = {
    # HandleLidSwitch = "hibernate";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
  services.syncthing.openDefaultPorts = true;

  boot = {
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
    };
    supportedFilesystems = {
      "ntfs" = true;
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  services.xserver = {
    xkb.options = "caps:escape";
  };
  console.useXkbConfig = true;

  # add fixed IPs for machines@home
  networking.extraHosts = ''
    192.168.178.48 snowfox
    192.168.178.54 snowstorm
  '';
}
