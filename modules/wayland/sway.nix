{ config, lib, pkgs, ...}:

{
    imports = [
        ./common.nix
    ];

    # services.xserver.displayManager = {
    # } // lib.optionalAttrs (builtins.hasAttr "gtkgreet" config.services.xserver.displayManager) {
    #     gtkgreet = {
    #         enable = true;
    #         entries = [{
    #             entryName = "sway";
    #             isXWM = false;
    #             cmd = "${config.programs.sway.package}/bin/sway";
    #             postCmd = ''
    #                 sleep 10
    #                 dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP \
    #                     && systemctl --user restart xdg-desktop-portal-wlr \
    #                     && ${pkgs.libnotify}/bin/notify-send "startup" "wlr and gtk portal service started"
    #                 dbus-launch --exit-with-session ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    #     '';
    #         }];
    #     };
    # };

	programs = {
		xwayland.enable = true;
		sway = {
			enable = true;
			wrapperFeatures = {
				base = true;
				gtk = true;
			};
			extraPackages = with pkgs; [
				ags
				foot
				grim
				inotify-tools
				kanshi
				slurp
				swayidle
				swaylock
				wev
				wf-recorder
				wl-clipboard
                glib
			];
		};
	};

    xdg = {
        terminal-exec.settings = {
            sway = [
                "org.codeberg.dnkl.foot"
            ];
        };
        portal = {
            enable = true;
            wlr = {
                enable = true;
            };
            extraPortals = with pkgs; [
                xdg-desktop-portal-gtk
            ];
            config.sway = {
                default = [ "wlr" "gtk" ];
            };
        };
    };
}
