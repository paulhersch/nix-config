{ pkgs, config, lib, ... }:
let
	awesome-run = pkgs.writeShellScriptBin "awesome-run" ''
		startx awesome -- -keeptty >~/.xorg.log 2>&1
	'';

	gtkgreet-wrap = pkgs.writeShellScriptBin "gtkgreet-styled" ''
		${pkgs.greetd.gtkgreet}/bin/gtkgreet \
			-s /etc/nixos/modules/display-manager/greetd/gtkgreet/style.css
	'';
	
	# cage needs this stupid wrapper so i can set ENV vars in the default_command of greetd
	cage = pkgs.writeShellScriptBin "cage" ''
		XKB_DEFAULT_LAYOUT='de' \
		${pkgs.cage}/bin/cage \
			-s -d $1
	'';
in
{
	services.xserver.displayManager.lightdm.enable = lib.mkForce false;
	services.xserver.displayManager.startx.enable = true;
	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${cage}/bin/cage gtkgreet-styled";
			};
		};
	};
	environment.systemPackages = [ awesome-run gtkgreet-wrap ];
	environment.etc."greetd/environments".text = ''
awesome-run
	'';
	# will start awesomewm with gnome polkit by default
	environment.etc."X11/xinit/xinitrc".text = import ./xinitrc.nix { pkgs = pkgs; };
}
