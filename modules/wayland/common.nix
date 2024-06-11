{ pkgs, ... }:

#
#  Contains settings mostly shared between compositors
#

{
    xdg.portal = {
        wlr = {
            settings = {  
            };
        };
        # extraPortals = [
        #     pkgs.xdg-desktop-portal-gtk
        # ];
    };
}
