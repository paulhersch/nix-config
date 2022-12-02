{ config, pkgs, lib, ... }:

let
	flake = (builtins.getFlake "https://github.com/hyprwm/Hyprland/archive/master.tar.gz");
	hyprland-pkg = flake.packages.${pkgs.system}.default;
	hyprland = pkgs.writeShellScriptBin "hyprland-run" ''
		${hyprland-pkg}/bin/Hyprland
	'';
in
{
	imports = [
		flake.nixosModules.default
	];
	
	environment.systemPackages = with pkgs; [
		hyprland
		hyprland-pkg
		foot
		fusuma
		grim
		slurp
		rofi
		wlogout
		wev
		waybar
	];

	# hyprland cachix
	nix.settings = {
		substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
	};
}
