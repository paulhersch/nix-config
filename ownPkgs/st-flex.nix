{ lib
, stdenv
, pkgs
, fetchFromGitHub
, pkg-config
, freetype
, fontconfig
, libX11
, libXft
, ncurses
, writeText
, addPatches ? []
, conf ? null
, extraLibs ? []
, ligatures ? false
, harfbuzzFeatures ? []
, harfbuzz ? null
}:

#warning: ligatures dont build for some godforsaken reason
assert ligatures -> harfbuzz != null;

let
	str = lib.strings;
	lst = lib.lists;
in

stdenv.mkDerivation rec {
	pname = "st-flexipatch";
	version = "e6a2fb4";
	src = fetchFromGitHub {
		owner = "bakkeby";
		repo = "st-flexipatch";
		rev = "e6a2fb489c192e2cd9439691014f48779d4966ad";
		hash = "sha256-DCsuRbJJbU2Ii4vnOyd1o21VqiXvo2Dz7PKOsDizvCc=";
	};
		
	configFile = lib.optionalString (conf != null)
		(writeText "config.def.h" conf);
	
	# creates the patches.h file, replaces spaces with underlines, capitalizes letters and adds "_PATCH"
	patchFile = writeText "patches.def.h" (
		lib.concatStrings (
			lib.concatMap (x: [ "#define ${str.toUpper x}_PATCH 1\n" ]) (
				map (y: str.stringAsChars (z: if z==" " then "_" else z) y)
					(addPatches ++ (if ligatures then [ "ligatures" ] else []))
	)));

	# builds the features array for hb.c
	hbFeatures = "hb_feature_t features[] = { " + (str.concatStringsSep ", " (lst.map (
		x: "FEATURE(" + (
			str.concatStringsSep ", " (
				# needs to be escaped for sed
				lst.map (y: "\'${y}\'") (str.stringToCharacters x)
		)) + ")"
	) harfbuzzFeatures)) + " };";

	postPatch = lib.optionalString (conf != null) "cp ${configFile} config.h \n"
		+ lib.optionalString (addPatches != []) "cp ${patchFile} patches.h \n"
		#uncomment lines for ligature support if enabled
		+ (if ligatures then ''
			sed -i 's/#LIGATURES_/LIGATURES_/' config.mk
			sed -i "30s/.*/${hbFeatures}/" hb.c
			''
		  else "")
		+ lib.optionalString stdenv.isDarwin ''
		substituteInPlace config.mk --replace "-lrt" ""
	'';

	strictDeps = true;
	makeFlags = [
		"PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
	];

	# offset before -1 -> 0 "packaging deps"
	depsBuildBuild = [ ncurses fontconfig freetype pkg-config ]
		++ (if ligatures then [ harfbuzz ] else []);
	
	# offset before 0 -> 1 "building deps"
	depsHostHost = [ libX11 libXft ]
		++ (if ligatures then [ harfbuzz ] else [])
		++ extraLibs;
	
	preInstall = ''
		export TERMINFO=$out/share/terminfo
	'';
	installFlags = [ "PREFIX=$(out)" ];
}
