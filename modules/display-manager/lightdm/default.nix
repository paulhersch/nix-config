{ config, pkgs, ... }:

{
  services.xserver = {
    displayManager = {
      lightdm = {
        enable = true;
        background = ./ldmbg.png;
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.gtk-custom;
            name = "Custom";
          };
          cursorTheme = {
            package = pkgs.phinger-cursors;
            name = "Phinger Cursors (light)";
          };
          iconTheme = {
            package = pkgs.papirus-maia-icon-theme;
            name = "Papirus-Dark";
          };
          indicators = [ "~session" "~spacer" ];
        };
      };
    };
  };
}
