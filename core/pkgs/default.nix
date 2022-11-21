{ pkgs, config, ... }:
let
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
	
	media = import ./media.nix { pkgs = pkgs; };
	basic = import ./basic.nix { pkgs = pkgs; unstable = unstable; };
	guiutils = import ./guiutils.nix { pkgs = pkgs; };
	cliutils = import ./cliutils.nix { pkgs = pkgs; };
	
	pythonpackages = with pkgs.python310Packages; [
		pandas
    		selenium
    		seaborn
    		python-lsp-server
    		keyring
    		tornado
    		requests
    		pynvim
    		pygobject3
		beautifulsoup4
	] ++ [ pkgs.gobject-introspection ];
in
{
	imports = [ ./fonts.nix ];
	environment.systemPackages = with pkgs; [
		pfetch
		cowsay
		fortune
	] ++ pythonpackages ++ media ++ guiutils ++ cliutils;
}
