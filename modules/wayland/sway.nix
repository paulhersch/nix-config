{ config, lib, pkgs, ...}:
{
	environment.systemPackages = with pkgs; [
		wl-clipboard
		oguri
		grim
		slurp
		wofi
		wlogout
		wev
		fusuma
		eww-wayland
		wf-recorder
		waybar
		unstable.foot
	];

	programs = {
		xwayland.enable = true;
		sway = {
			enable = true;
			wrapperFeatures = { base = true; gtk = true; };
		};
	};
}
