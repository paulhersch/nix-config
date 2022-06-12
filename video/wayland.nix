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
	nixpkgs.overlays = [
		(final: prev: {
			river = prev.river.overrideAttrs (old: rec {
				postInstall = ''
					mkdir -p $out/share/wayland-sessions/
					cp contrib/river.desktop $out/share/wayland-sessions/river.desktop
				'';
				passthru.providedSessions = [ "river" ];
			});
		})
	];
	environment.systemPackages = with pkgs; [
		wl-clipboard
		wlroots
		oguri
		mako
		waybar
		clipman
		grim
		obs-studio
		obs-studio-plugins.wlrobs
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
		river
		kile-wl
	];
	services.xserver.displayManager.sessionPackages = [ pkgs.river ];

	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
	};

	programs.hyprland.enable = true;
	xdg = {
		portal = {
			wlr.enable = true;
		};
	};
   	programs.xwayland.enable = true;
}
