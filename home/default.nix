{ lib, ... }:
{
	imports = [
		./manager.nix
		./paul
		./luise.nix
	];
}
