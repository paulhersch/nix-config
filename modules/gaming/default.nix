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
	];
	stablepkgs = with pkgs; [
		openrazer-daemon
		razergenie
		#wine-ge
	];
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
	environment.systemPackages = stablepkgs ++ unstablepkgs;
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
