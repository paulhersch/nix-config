{ config, lib, pkgs, ...}:
let
#   waylandOverlay = (import "${builtins.fetchTarball "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz" }/overlay.nix");

   #hyprland
#   flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
#   hyprland = (import flake-compat {
#     src = builtins.fetchTarball "https://github.com/vaxerski/Hyprland/archive/master.tar.gz";
#   }).defaultNix;
in
{
#	imports = [
#		hyprland.nixosModules.default
#	];
#	nixpkgs.overlays = [
#		waylandOverlay
#	];
	environment.systemPackages = with pkgs; [
		wl-clipboard
		oguri
#		mako #already provided by home manager unit
		grim
		slurp
#		obs-wlrobs
		wofi
		alacritty
		foot
		wlogout
		wev
		fusuma
#		kanshi
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
#		hyprland.enable = true;
	};
#	xdg = {
#		portal = {
#			enable = true;
#			gtkUsePortal = true;
#			wlr.enable = true;
#		};
#	};
}
