{ lib, ... }:
{
	imports = [
		./x.nix
		./wayland.nix
		./theming
	];
}
