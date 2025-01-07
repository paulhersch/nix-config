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
            systemctl --user stop xdg-desktop-portal\*
            systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
            # start "subportals" first so default xdg can find everything
            systemctl --user start xdg-desktop-portal-wlr xdg-desktop-portal-gtk
            systemctl --user start xdg-desktop-portal
        '';
    in with pkgs; [
        xdg-fix
        foot
    ];
}
