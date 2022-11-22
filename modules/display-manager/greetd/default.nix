{ pkgs, config, lib, ... }:
let
	swayConfig = pkgs.writeText "greetd-sway-config" ''
		exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c startx awesome; swaymsg exit"
		bindsym Mod1+shift+e exec swaynag \
		-t warning \
		-m 'What do you want to do?' \
		-b 'Poweroff' 'systemctl poweroff' \
		-b 'Reboot' 'systemctl reboot'
	'';
in
{
	services.xserver.displayManager.lightdm.enable = lib.mkForce false;
	services.xserver.displayManager.startx.enable = true;
	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				#command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd '${pkgs.xorg.xinit}/bin/startx awesome'";
				#command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
				command = "${pkgs.cage}/bin/cage -s ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
			};
		};
	};
	environment.etc."greetd/environments".text = ''
		startx awesome
	'';
	# will start awesomewm with gnome polkit by default
	environment.etc."X11/xinit/xinitrc".text = import ./xinitrc.nix { pkgs = pkgs; };
}
