{ stdenv
, stdenvAdapters
, lib
, pkgs
, fetchurl
, mono5
, gmp
, unzip
, makeWrapper
, ...
}:
let
  # ld breaks on binutils 2.39
  util_2_38_stdenv = stdenv:
    stdenvAdapters.overrideInStdenv stdenv [ pkgs.binutils-unwrapped_2_38 ];
in
(util_2_38_stdenv stdenv).mkDerivation rec {
  pname = "satk";
  version = "0.3.5-347";
  meta = with lib; {
    description = "Compiler for SatherK (version from MLU Halle)";
    longDescription = "SatherK is a sublanguage of Sather. This compiler has been made at the MLU Halle, Department for Computer Science.";
    homepage = "https://swt.informatik.uni-halle.de/software/satherkhalle/";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  src = fetchurl {
    url = "https://swt2.informatik.uni-halle.de/downloads/Software/satk_${version}.zip";
    sha256 = "d887d5bd5967eb3ee1156159af5b2a552c8f23e50ce3de7877ef5d3cc5add9b1";
  };

  depsBuildBuild = with pkgs; [ gmp unzip makeWrapper ];
  depsTargetTarget = with pkgs; [ mono5 gmp ];

  buildPhase = ''
    		cd src
    		make
    		cd ..
    	'';

  installPhase = ''
    		mkdir -p $out/bin $out/lib/satk
    		cp bin/satk $out/bin/satk
    		cp -r lib/* $out/lib/satk/
    		runHook postInstall
    	'';

  postInstall = ''
    		wrapProgram $out/bin/satk \
    			--set SAKCILCOMP "${pkgs.mono5}/bin/ilasm" \
    			--set SAKLIBPATH "$out/lib/satk"
    	'';
}
