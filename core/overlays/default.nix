{ lib, pkgs, config, ... }:
{
	nixpkgs.overlays = [
		(builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
	];
}
