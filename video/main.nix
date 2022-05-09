{ lib, ... }:
{
	imports = [
		./x.nix
		./wayland.nix #it broki
		./theming/main.nix
	];
}
