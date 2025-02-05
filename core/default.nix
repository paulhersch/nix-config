{ lib, pkgs, config, ... }:

{
  imports = [
    ./services
    ./security
    ./pkgs
    ./zsh
  ];
  # nixpkgs.config.allowUnfree = true;

  # GPG + pinentry
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
  programs.virt-manager = {
    enable = true;
  };
  services.spice-vdagentd.enable = true;
  security.wrappers.spice-client-glib-usb-acl-helper = {
    source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
    owner = "root";
    group = "root";
  };
  environment.systemPackages = with pkgs; [ virtiofsd ];
}
