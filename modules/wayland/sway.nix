{ config, lib, pkgs, ...}:
{
	environment.systemPackages = with pkgs; [
		wl-clipboard
		oguri
		grim
		slurp
		wofi
		foot
		wlogout
		wev
		fusuma
		eww-wayland
		wf-recorder
		waybar
	];

	programs = {
		xwayland.enable = true;
		sway = {
			enable = true;
			wrapperFeatures = { base = true; gtk = true; };
		};
	};
}
