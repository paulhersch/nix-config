{ pkgs, ... }:

#
#  Contains settings mostly shared between compositors
#

{
    xdg = {
        terminal-exec = {
            enable = true;
            settings.default = [
                "org.codeberg.dnkl.foot"
            ];
        };
        portal = {
            wlr = {
                settings = {  
                };
            };
            extraPortals = [
                pkgs.xdg-desktop-portal-gtk
            ];
        };
    };

    environment.systemPackages = let
        xdg-fix = pkgs.writeShellScriptBin "wayland-xdg-fix" ''
            systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
            systemctl --user restart xdg-desktop-portal.service
        '';
    in with pkgs; [
        xdg-fix
        foot
    ];
}
