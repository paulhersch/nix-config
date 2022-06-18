{ pkgs, ... }:
{
	environment.systemPackages = [
		(pkgs.callPackage ./satk.nix {})
#		(pkgs.callPackage ./sddm-sugar-dark.nix {})
	];
}
