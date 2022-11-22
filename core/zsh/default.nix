{ config, lib, pkgs, ... }:
{
	# zsh globally
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		enableBashCompletion = true;
		autosuggestions = {
			enable = true;
			async = true;
		};
		syntaxHighlighting = {
			enable = true;
		};
	};
}
