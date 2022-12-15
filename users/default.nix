{ lib, config, home-manager, ... }:
{
	imports = [
		./paul
		./luise
		#<home-manager/nixos>
	];
	system.userActivationScripts = {
		xinitrc.text = ''ln -sf "/etc/X11/xinit/xinitrc" "$HOME/.xinitrc"'';
	};
}
