{ config, lib, pkgs, ...}:
{
    services.xserver.displayManager = {
    } // lib.optionalAttrs (builtins.hasAttr "gtkgreet" config.services.xserver.displayManager) {
        gtkgreet = {
            enable = true;
            entries = [{
                entryName = "sway";
                isXWM = false;
                cmd = "${config.programs.sway.package}/bin/sway |& tee sway.log";
		        postCmd = ''
                    dbus-launch --exit-with-session ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
                    dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
		'';
            }];
        };
    };

	programs = {
		xwayland.enable = true;
		sway = {
			enable = true;
			wrapperFeatures = {
				base = true;
				gtk = true;
			};
			extraPackages = with pkgs; [
				wl-clipboard
				swaylock
				swayidle
				grim
				slurp
				wev
				kanshi
				ags
				inotify-tools
				wf-recorder
				foot
			];
		};
	};

    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
        ];
        config.sway = {
            default = [ "wlr" "gtk" ];
        };
    };
}
