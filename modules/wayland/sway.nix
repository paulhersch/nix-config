{ config, lib, pkgs, ...}:
{
	#services.xserver.displayManager.gtkgreet = {
	#	enable = true;
	#	entries = [
	#		{
	#			entryName = "sway";
	#			isXWM = false;
	#			cmd = "${pkgs.sway}/bin/sway";
	#			postCmd = "dbus-launch ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
	#		}
	#	];
	#};

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
		unstable.foot
	];

	programs = {
		xwayland.enable = true;
		sway = {
			enable = true;
			wrapperFeatures = {
				base = true;
				gtk = true;
			};
			package = pkgs.unstable.swayfx;
			extraSessionCommands = ''
				dbus-launch --exit-with-session ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
			'';
		};
	};
}
