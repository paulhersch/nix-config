{ lib, pkgs, config, ... }:

{
	imports = [
		./overlays
		./services
		./security
		./pkgs
		./zsh
	];
	nixpkgs.config.allowUnfree = true;
	
	# GPG + pinentry
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		pinentryFlavor = "curses";
	};
}
