{ config, pkgs, ... }:

{
  imports =
    [
      ./hwconf.nix
      ../../core/zsh
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    keyMap = "de";
  };

  users.users.witzer = {
    isNormalUser = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh.enable = true;

  security = {
    sudo.enable = false;
    protectKernelImage = true;
    apparmor.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
    };
    settings.auto-optimise-store = true;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}

