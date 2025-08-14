{ config, pkgs, lib, options, ... }:
# I want to use lua (coming from awesome wm) to serve
# the data eww needs. this lua env is botched together here
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.systemPackages = with pkgs; [
    foot
    gammastep
    grim
    inotify-tools
    kanshi
    nemo-with-extensions
    networkmanagerapplet
    quickshell
    slurp
    wev
    wl-clipboard
    wlr-randr
  ];

  xdg = {
    terminal-exec.settings = {
      river = [
        "org.codeberg.dnkl.foot"
      ];
    };
    portal = {
      enable = true;
      wlr = {
        enable = true;
      };
      config.hyprland = {
        default = [ "wlr" "gtk" ];
      };
    };
  };
}
