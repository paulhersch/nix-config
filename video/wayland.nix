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
#		(final: prev: {
#			river = prev.river.overrideAttrs (old: rec {
#				postInstall = ''
#					mkdir -p $out/share/wayland-sessions/
#					cp contrib/river.desktop $out/share/wayland-sessions/river.desktop
#				'';
#				passthru.providedSessions = [ "river" ];
#			});
#		})
		waylandOverlay
	];
	environment.systemPackages = with pkgs; [
		wl-clipboard
		oguri
		mako
		waybar
		clipman
		grim
		slurp
		obs-studio
		obs-wlrobs
		wofi
		swayidle
		swaylock
		alacritty
		foot
		wlogout
		wev
		fusuma
		kanshi
		eww-wayland
		wf-recorder
#		river-git
#		wayfire-unstable
#		kile-wl
	];
#	services.xserver.displayManager.sessionPackages = [ pkgs.river ];

	programs = {
		xwayland.enable = true;

		sway = {
			enable = true;
			wrapperFeatures.gtk = true;
		};
		hyprland.enable = true;
	};
	xdg = {
		portal = {
			enable = true;
			wlr.enable = true;
		};
	};
}
