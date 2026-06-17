{ pkgs, config, ... }:
{

  imports = [
    ../wayland/xwayland-satellite.nix
  ];

  programs = {
    nm-applet = {
      enable = true;
      indicator = true;
    };
    niri.enable = true;
    xwayland-satellite.enable = false; # niri handles integration
  };

  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    nemo-with-extensions
    gammastep
    glib
    grim
    inotify-tools
    kanshi
    # libastal-lua
    quickshell
    networkmanagerapplet
    swaylock
    awww
    tofi
    wev
    wl-clipboard
    wlogout
    xwayland-satellite
  ];

  xdg = {
    portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config.niri = {
        # default = [
        #   "gtk"
        #   "gnome"
        # ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };
}
