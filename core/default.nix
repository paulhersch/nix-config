{ lib, pkgs, config, ... }:

{
	imports = [
		./services
		./security
		./pkgs
		./zsh
	];
	# nixpkgs.config.allowUnfree = true;
	
	# GPG + pinentry
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		pinentryFlavor = "gtk2";
	};
}
