{ lib, ... }:

{
  services.greetd.enable = true;
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
        theme_name = "Materia-custom";
      };
    };
  };
}
