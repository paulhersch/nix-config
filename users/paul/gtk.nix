{ pkgs }:
{
  enable = true;
  font = {
    name = "Aporetic Serif Medium";
    size = 11;
    package = pkgs.aporetic;
  };
  iconTheme = {
    name = "Papirus-Light";
    package = pkgs.papirus-icon-theme;
  };
  cursorTheme = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
  };
  theme = {
    name = "Materia-custom";
    package = pkgs.gtk-materia-custom;
  };
  gtk2 = {
    configLocation = "/home/paul/.gtkrc-2.0";
    extraConfig = ''
      			include "/home/paul/.gtkrc-2.0.mine"
      			gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
      			gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      			gtk-button-images=0
      			gtk-menu-images=0
      			gtk-enable-event-sounds=0
      			gtk-enable-input-feedback-sounds=0
      			gtk-xft-antialias=1
      			gtk-xft-hinting=1
      			gtk-xft-hintstyle="hintslight"
      			gtk-xft-rgba="rgb"
      			'';
  };
}
