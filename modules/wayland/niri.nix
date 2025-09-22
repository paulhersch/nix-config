{ pkgs, config, ... }: {

  imports = [
    ../wayland/xwayland-satellite.nix
  ];

  programs = {
    nm-applet = {
      enable = true;
      indicator = true;
    };
    niri.enable = true;
    xwayland-satellite.enable = true;
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
    swww
    tofi
    wev
    wl-clipboard
  ];

  xdg = {
    portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config.niri = {
        default = [ "gtk" "gnome" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  # systemd.user.services."quickshell-daemon" = {
  #   description = "Niri's quickshell background process";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.quickshell}/bin/qs";
  #     Restart = "on-failure";
  #     RestartSec = 5;
  #   };
  #   wantedBy = [ "niri.service" ];
  #   after = [ "niri.service" ];
  #   partOf = [ "graphical-session.target" ];
  # };
}
