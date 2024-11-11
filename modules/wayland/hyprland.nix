{ config, pkgs, lib, options, ... }:
# I want to use lua (coming from awesome wm) to serve
# the data eww needs. this lua env is botched together here
let
	lua-stuff = import ../display-mixed/awm-lua-env.nix {
		inherit config lib pkgs options;
	};

	luaEnvSearchPath = lib.concatMapStringsSep ";" (path:
		(lua-stuff.getLuaPath path "share") + "/?.lua;" +
		(lua-stuff.getLuaPath path "lib") + "/?.lua"
	) lua-stuff.modules;
	luaCenvSearchPath = lib.concatMapStringsSep ";" (path:
		(lua-stuff.getLuaPath path "share") + "/?.so;" +
		(lua-stuff.getLuaPath path "lib") + "/?.so"
	) lua-stuff.modules;

	eww-lua-env = pkgs.writeShellScriptBin "eww-lua" ''
		export LUA_PATH="''${LUA_PATH};${luaEnvSearchPath}"
		export LUA_CPATH="''${LUA_CPATH};${luaCenvSearchPath}"
		${pkgs.luajit}/bin/luajit $@
	'';
in
{
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	environment.systemPackages = with pkgs; [
		# pinnacle-comp
		foot
		fusuma
		grim
		slurp
		rofi
		wlogout
		wev
		ags
		# eww-wayland
		# eww-lua-env
		oguri
		inotify-tools
	];

	xdg.portal = {
		enable = true;
		wlr.enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-hyprland
			xdg-desktop-portal-gtk
		];
	};
}
