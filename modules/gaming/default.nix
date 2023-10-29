{ pkgs, config, lib, ...}:

let
	unstablepkgs = with pkgs.unstable; [
		steam
		# heroic
		# gamescope
		prismlauncher
		factorio
	];
	stablepkgs = with pkgs; [
		polychromatic
	];
in
{
	environment.systemPackages = unstablepkgs ++ stablepkgs;
	programs = {
		steam = {
			enable = true;
		};
		gamemode = {
			enable = true;
			enableRenice = true;
		};
	};
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
