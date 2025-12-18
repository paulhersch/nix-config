{ config
, pkgs
, ...
}:

{
  services.greetd.enable = true;
  services.xserver.displayManager.startx.enable = config.services.xserver.enable; # only enable startx if x exists
  programs.regreet = {
    enable = true;
    cageArgs = [
      "-m"
      "last"
    ];
    cursorTheme = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
    };
    font = {
      name = "Aporetic Serif Medium";
      size = 11;
      package = pkgs.aporetic;
    };
    iconTheme = {
      name = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Custom-Light";
      package = pkgs.gtk-custom;
    };
    settings = {
      background = {
        path = builtins.path {
          path = ./regreet-bg.jpeg;
          name = "regreet-wallpaper";
        };
        fit = "Cover";
      };
    };
  };
}
