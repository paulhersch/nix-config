{ config, lib, pkgs, ...}:
let
   rev = "master";
   url = "https://github.com/nix-community/nixpkgs-wayland/archive/${rev}.tar.gz";
   waylandOverlay = (import "${builtins.fetchTarball url}/overlay.nix");
in
{
	nixpkgs.overlays = [ waylandOverlay ];
	environment.systemPackages = with pkgs; [
		wl-clipboard
		wlroots
		wlay
		oguri
		lavalauncher
		mako
		waybar
		clipman
		grim
		obs-studio
		obs-wlrobs
		wofi
		swayidle
		swaylock
		alacritty
		wlogout
		wev
	];
	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
	};
	xdg = {
		portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-wlr
			];
		};
	};
   	programs.xwayland.enable = true;
}
