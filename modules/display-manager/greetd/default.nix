{ pkgs
, config
, lib
, ...
}:
with lib;
let
	cfg = config.services.xserver.displayManager.gtkgreet;
	
	lst = lib.lists;
	str = lib.strings;

	colors = import ../../../globals/colors.nix {};
	css = pkgs.writeText "style.css" (
		import ./gtkgreet/style.css.nix { inherit colors; });
	
	gtkgreet-wrap = pkgs.writeShellScriptBin "gtkgreet-styled" ''
		${pkgs.greetd.gtkgreet}/bin/gtkgreet \
			-s ${css}
	'';
	
	# cage needs this stupid wrapper so i can set ENV vars in the default_command of greetd
	cage = pkgs.writeShellScriptBin "cage" ''
		XKB_DEFAULT_LAYOUT='de' \
		${pkgs.cage}/bin/cage \
			-s -d $1
	'';
	
	# if there is a wayland session no xinitrcentry should be provided
	entryType = types.submodule { options = {
		entryName = mkOption {
			type = types.str;
			example = "awesome";
		};
		cmd = mkOption {
			type = types.str;
			example = ''
				awesome
			'';
			description = "The WM/DE/Compositor executable to be run";
		};
		preCmd = mkOption {
			type = types.str;
			default = "";
			example = ''
				export GDK_SCALE=2
			'';
		};
		postCmd = mkOption {
			type = types.str;
			default = "";
			example = ''
				xrdb -load .Xresources
			'';
		};
		isXWM = mkOption {
			type = types.bool;
			default = false;
		};
	};};

in
{
	options = {
		services.xserver.displayManager.gtkgreet = {
			enable = mkEnableOption "Enables gtk-greet as login manager";
			entries = mkOption {
				type = types.listOf entryType;
				default = [];
				example = ''
					[{
						startCmd = \'\'
							awesome &
							xrdb -load ~/.Xresources
							dbus-launch --exit-with-x11 ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
						\'\';
						isXWM = true;
					}];
				'';
			};
		};
	};
	config = mkIf cfg.enable {
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
		
		# if xinitrc exists we assume and X WM -> wrapper for silent startx with -run suffix (startx awesome -> awesome-run)
		environment.systemPackages = [ gtkgreet-wrap ]
			++ (lst.foldl (prev: curr: prev ++ [(pkgs.writeShellScriptBin (curr.entryName + "-run")
				(if curr.isXWM
					then "session=${curr.entryName} startx -- -keeptty >~/.xorg.log 2>&1\n"
					else "${curr.preCmd}\n${curr.cmd}\n${curr.postCmd}"
				))]) [] cfg.entries);
		environment.etc = {
			# concat start cmd strings with \n for type lines
			"greetd/environments".text = lst.foldl (
				prev: curr:
					if prev != "" then prev + "\n" + curr
					else curr
				) "" (
					lst.foldl (prev: curr: prev ++ [(
						curr.entryName + "-run"
					)]) [] cfg.entries
				);
			
			"X11/xinit/xinitrc".text =  
				"case $session in\n"
				+ (lst.head (lst.foldl (prev: curr: if curr.isXWM != null
					then
						prev ++ [("${curr.entryName})\n"
							+ curr.preCmd + "\n"
							+ curr.cmd + " &\n"
							+ curr.postCmd + "\n"
							+ "\n;;\n"
						)]
					else prev)
				    [] cfg.entries))
				+ "*)\n    exec $session\n;;\n"
				+ "esac";
		};
	};
}
