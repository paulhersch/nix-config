{ config, lib, pkgs, ...}:
let
#   rev = "master";
#   waylandOverlayurl = 
   waylandOverlay = (import "${builtins.fetchTarball "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz" }/overlay.nix");

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
	nixpkgs.overlays = [
		waylandOverlay
	];
	environment.systemPackages = with pkgs; [
		wl-clipboard
		oguri
		mako
		grim
		slurp
		obs-wlrobs
		wofi
		alacritty
		foot
		wlogout
		wev
		fusuma
		kanshi
		eww-wayland
		wf-recorder
	];

	programs = {
		xwayland.enable = true;
		hyprland.enable = true;
	};
	xdg = {
		portal = {
			enable = true;
			wlr.enable = true;
		};
	};
}
