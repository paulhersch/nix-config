{ pkgs, config, lib, ...}:
let
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
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
	environment.systemPackages = [
		unstable.steam
		unstable.heroic
	];
	hardware = {
		openrazer = {
			enable = true;
			users = [ "paul" ];
			devicesOffOnScreensaver = false;
		};
		opengl = {
			extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
			driSupport32Bit = true;
		};
	};
  	powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  	boot.kernelPackages = unstable.linuxPackages_latest;
	boot.kernelModules = [ "openrazer" ];
}
