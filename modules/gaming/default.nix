{ pkgs, config, lib, ...}:
#let
#	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
#	sway-config = pkgs.writeText "steam-sway-config" ''
#		exec "${unstable.steam}/bin/steam; swaymsg exit"
#		bindsym Mod1+shift+e exec swaynag \
#			-t warning \
#			-m 'What do you want to do?' \
#			-b 'Poweroff' 'systemctl poweroff' \
#			-b 'Reboot' 'systemctl reboot'
#	'';
#	steam-sway = pkgs.writeShellScriptBin "steam-session-sway" ''
#		${pkgs.sway}/bin/sway --config ${sway-config}
#	'';
#in

let
	unstablepkgs = with pkgs.unstable; [
		steam
		heroic
		gamescope
		prismlauncher
	];
	stablepkgs = with pkgs; [
		openrazer-daemon
		# razergenie
		polychromatic
		# wine-ge
	];
	freesyncsteam = pkgs.writeShellScriptBin "freesyncgamescope" ''
		${pkgs.gamescope}/bin/gamescope -r 144 -w 2560 -h 1440 -W 1920 -H 1080 -U -f --adaptive-sync -- steam
	'';
in
{
	programs = {
		steam = {
			enable = true;
		};
		gamemode = {
			enable = true;
			enableRenice = true;
		};
	};
	environment.systemPackages = stablepkgs ++ unstablepkgs ++ [
		freesyncsteam
	];
	hardware = {
		openrazer = {
			enable = true;
			users = [ "paul" "luise" ];
		};
		opengl = {
			extraPackages = with pkgs; [ libva libva-utils ];
			extraPackages32 = with pkgs.pkgsi686Linux; [ libva libva-utils ];
			driSupport32Bit = true;
		};
	};
  	powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
