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
            }];
        };
    };

	environment.systemPackages = with pkgs; [
		wl-clipboard
		oguri
		grim
		slurp
		wofi
		wlogout
		wev
		fusuma
		# eww-wayland
		ags
		inotify-tools
		wf-recorder
		waybar
		foot
	];

	programs = {
		xwayland.enable = true;
		sway = {
			enable = true;
			wrapperFeatures = {
				base = true;
				gtk = true;
			};
			extraSessionCommands = ''
				dbus-launch --exit-with-session ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
			'';
		};
	};
}
