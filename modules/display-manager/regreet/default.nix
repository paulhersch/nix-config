{ lib, config, ... }:

{
  services.greetd.enable = true;
  services.xserver.displayManager.startx.enable = config.services.xserver.enable; # only enable startx if x exists
  programs.regreet = {
    enable = true;
    cageArgs = [ "-m" "last" ];
    settings = {
      background = {
        path = builtins.path {
          path = ./regreet-bg.jpeg;
          name = "regreet-wallpaper";
        };
        fit = "Cover";
      };
      GTK = lib.mkForce {
        cursor_theme_name = "phinger-cursors-dark";
        font_name = "Aporetic Serif Medium 11";
        icon_theme_name = "Papirus-Light";
        theme_name = "Custom";
      };
    };
  };
}
