{ pkgs, config, ... }:
let
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
	
	media = import ./media.nix { pkgs = pkgs; };
	basic = import ./basic.nix { pkgs = pkgs; unstable = unstable; };
	guiutils = import ./guiutils.nix { pkgs = pkgs; };
	cliutils = import ./cliutils.nix { pkgs = pkgs; };
	pythonpackages = import ./python.nix { pkgs = pkgs; };
in
{
	imports = [ ./fonts.nix ];
	environment.systemPackages = with pkgs; [
		pfetch
		cowsay
		fortune
		#(pkgs.callPackage ../../pkgs/satk.nix {})
	]
	++ pythonpackages
	++ basic
	++ media
	++ guiutils
	++ cliutils;
}
