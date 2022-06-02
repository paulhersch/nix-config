{ config, lib, pkgs, ...}:
let
   rev = "master";
   url = "https://github.com/nix-community/nixpkgs-wayland/archive/${rev}.tar.gz";
   waylandOverlay = (import "${builtins.fetchTarball url}/overlay.nix");

   #hyprland
   flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
   hyprland = (import flake-compat {
     src = builtins.fetchTarball "https://github.com/vaxerski/Hyprland/archive/master.tar.gz";
   }).defaultNix;

in
{
	imports = [
	  hyprland.nixosModules.default
	];

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
	programs.hyprland.enable = true;
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
