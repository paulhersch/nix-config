{ pkgs, config, lib, ...}:
let
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
	sway-config = pkgs.writeText "steam-sway-config" ''
		exec "${unstable.steam}/bin/steam; swaymsg exit"
		bindsym Mod1+shift+e exec swaynag \
			-t warning \
			-m 'What do you want to do?' \
			-b 'Poweroff' 'systemctl poweroff' \
			-b 'Reboot' 'systemctl reboot'
	'';
	steam-sway = pkgs.writeShellScriptBin "steam-session-sway" ''
		${pkgs.sway}/bin/sway --config ${sway-config}
	'';
in
{
	imports = [
		../wayland/sway.nix
	];
	programs = {
		steam = {
			enable = true;
		};
		gamemode = {
			enable = true;
			enableRenice = true;
		};
	};
	environment.systemPackages = [
		unstable.steam
		unstable.heroic
		unstable.gamescope
	];
	hardware = {
		opengl = {
			extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
			driSupport32Bit = true;
		};
	};
  	powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
