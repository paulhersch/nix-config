{ lib, ... }:
{
	imports = [
		./manager.nix
		./paul.nix
		./luise.nix
	];
}
