{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  somewm-withlibs = pkgs.somewm.override {
    extraGIPackages = with pkgs; [
      at-spi2-atk
      upower
    ];
    extraLuaPackages =
      p: with p; [
        rapidjson
        fzy
        ldbus
        lgi
      ];
  };
in
{
  imports = [
    ./common.nix
  ];

  environment.systemPackages = with pkgs; [
    nemo-with-extensions
    foot
    gammastep
    glib
    grim
    kanshi
    networkmanagerapplet
    slurp
    awww
    wl-clipboard
    wlr-randr
    somewm-withlibs
  ];

  # allow indexing from regreet
  services.displayManager.sessionPackages = [ somewm-withlibs ];

  programs.xwayland.enable = true;

  xdg = {
    terminal-exec.settings = {
      somewm = [
        "org.codeberg.dnkl.foot"
      ];
    };
    portal = {
      enable = true;
      wlr = {
        enable = true;
      };
      config.somewm = {
        default = [
          "wlr"
          "gtk"
        ];
      };
    };
  };
}
