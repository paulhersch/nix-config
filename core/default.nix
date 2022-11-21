{ lib, pkgs, config, ... }:

{
	imports = [
		./overlays
		./services
		./security
		./pkgs
	];
	nixpkgs.config.allowUnfree = true;
}
