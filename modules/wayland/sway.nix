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
            extraOptions = [
                "--unsupported-gpu"
            ];
			extraPackages = with pkgs; [
                ags
                nemo-with-extensions
                foot
                gammastep
                glib
                grim
                inotify-tools
                kanshi
                libastal-lua
                networkmanagerapplet
                slurp
                swayidle
                swaylock
                tofi
                wev
                wl-clipboard
                wlr-randr
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
            config.sway = {
                default = [ "wlr" "gtk" ];
            };
        };
    };
}
