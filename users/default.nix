{ pkgs, lib, config, home-manager, ... }:
{
	imports = [
		./paul
		./luise
	];
	#home-manager.users.paul = import ./paul;
	system.userActivationScripts = {
		xinitrc.text = ''ln -sf "/etc/X11/xinit/xinitrc" "$HOME/.xinitrc"'';
		libtcmalloc = ''
			[[ ! -e randomsymlinks ]] && mkdir randomsymlinks
			ln -sf "${pkgs.gperftools}/lib/libtcmalloc_minial.so" "$HOME/randomsymlinks/libtcmalloc_minimal.so"
		'';
	};
}
