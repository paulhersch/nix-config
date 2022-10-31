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
}:

#warning: ligatures dont build for some godforsaken reason

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
	
	patchFile = writeText "patches.def.h" (
		lib.concatStrings (
			lib.concatMap (x: [ "#define ${lib.strings.toUpper x}_PATCH 1\n" ]) (
				map (y: lib.strings.stringAsChars (z: if z==" " then "_" else z) y) addPatches
	)));

	postPatch = lib.optionalString (conf != null) "cp ${configFile} config.h \n"
		+ lib.optionalString (addPatches != []) "cp ${patchFile} patches.h \n"
		#uncomment lines for ligature support if enabled
		+ (if ligatures then "sed 's/#LIGATURES_/LIGATURES/' \n" else "")
		+ lib.optionalString stdenv.isDarwin ''
		substituteInPlace config.mk --replace "-lrt" ""
	'';

	strictDeps = true;
	makeFlags = [
		"PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
	];

	nativeBuildInputs = [ pkg-config ncurses fontconfig freetype ];
	buildInputs = [ libX11 libXft ]
		++ (if ligatures then [ pkgs.harfbuzz.dev ] else [])
		++ extraLibs;
	
	preInstall = ''
		export TERMINFO=$out/share/terminfo
	'';
	installFlags = [ "PREFIX=$(out)" ];
}
