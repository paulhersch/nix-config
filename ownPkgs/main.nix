{ pkgs, ... }:
{
	environment.systemPackages = [
		(pkgs.callPackage ./satk.nix {})
	];
}
