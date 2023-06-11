{ lib
, stdenv
, pkgs
, fetchFromGitHub
, pkg-config
, freetype
, fontconfig
, libX11
, libXft
, harfbuzz ? null
, libXcursor ? null
, libXrender ? null
, libsixel ? null
, ncurses
, writeText
, addPatches ? []
, conf ? null
, harfbuzzFeatures ? []
}:

let
	str = lib.strings;
	lst = lib.lists;

	# booleans for patches that require some extra libs and settings
	# can this be made easier?
	ligatures = lst.any (x: x == "ligatures") addPatches;
	themedCursor = lst.any (x: x == "themed cursor") addPatches;
	alpha = lst.any (x: x == "alpha") addPatches;
	sixel = lst.any (x: x == "sixel") addPatches;
in

# use libs if needed
assert ligatures -> harfbuzz != null;
assert themedCursor -> libXcursor != null;
assert alpha -> libXrender != null;
assert sixel -> libsixel != null;

stdenv.mkDerivation rec {
	pname = "st-flexipatch";
	version = "1343b29";
	src = fetchFromGitHub {
		owner = "bakkeby";
		repo = "st-flexipatch";
		rev = "1343b29ee5e8a9d67607a4616f74386a2951e276";
		hash = "sha256-cZcoBkgcG+MXVSmjupdmhEQv7j54rANbmMso6XnatEw=";
	};
		
	configFile = lib.optionalString (conf != null)
		(writeText "config.def.h" conf);
	
	# creates the patches.h file, replaces spaces with underlines, capitalizes letters and adds "_PATCH"
	patchFile = writeText "patches.def.h" (
		lib.concatStrings (
			lib.concatMap (x: [ "#define ${str.toUpper x}_PATCH 1\n" ]) (
				map (y: str.stringAsChars (z: if z==" " then "_" else z) y) addPatches
	)));

	# builds the features array for hb.c (currently broken, see https://github.com/cog1to/st-ligatures/issues/24)
	hbFeatures = "hb_feature_t features[] = { " + (str.concatStringsSep ", " (lst.map (
		x: "FEATURE(" + (
			str.concatStringsSep ", " (
				# needs to be escaped for sed
				lst.map (y: "\'${y}\'") (str.stringToCharacters x)
		)) + ")"
	) harfbuzzFeatures)) + " };";

	postPatch = lib.optionalString (conf != null) "cp ${configFile} config.h \n"
		+ lib.optionalString (addPatches != []) "cp ${patchFile} patches.h \n"
		
		#uncomment lines for patch libs
		+ (if ligatures then ''
			sed -i 's/#LIGATURES_/LIGATURES_/' config.mk
			sed -i "30s/.*/${hbFeatures}/" hb.c
			''
		  else "")
		+ (if themedCursor then ''
			sed -i "19s/.//" config.mk
			''
		  else "")
		+ (if alpha then ''
			sed -i "16s/.//" config.mk
			''
		  else "")
		+ (if sixel then ''
			sed -i "28s/.//" config.mk
			''
		  else "")
		+ lib.optionalString stdenv.isDarwin ''
		substituteInPlace config.mk --replace "-lrt" ""
	'';

	strictDeps = true;
	makeFlags = [
		"PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
	];

	depsBuildBuild = [ ncurses fontconfig freetype pkg-config ]
		++ (if ligatures then [ harfbuzz ] else [])
		++ (if themedCursor then [ libXcursor ] else [])
		++ (if alpha then [ libXrender ] else [])
		++ (if sixel then [ libsixel ] else []);
	
	depsHostHost = [ libX11 libXft ]
		++ (if ligatures then [ harfbuzz ] else [])
		++ (if themedCursor then [ libXcursor ] else [])
		++ (if alpha then [ libXrender ] else [])
		++ (if sixel then [ libsixel ] else []);
	
	preInstall = ''
		export TERMINFO=$out/share/terminfo
	'';
	installFlags = [ "PREFIX=$(out)" ];
}
