{ stdenv, pkgs, fetchurl, ... }:
let
  pname = "sddm-sugar-dark";
  ver = "1.2";
in
stdenv.mkDerivation {
  name = "${pname}-${ver}";
  src = fetchurl {
    url = "https://github.com/MarianArlt/sddm-sugar-dark/archive/master.tar.gz";
    hash = "sha256-1j7zPBJzW4S/RiPYdU7F7bSTKMK8dMV9j3jIWS2MzKI=";
  };

  dontBuild = true;
  installPhase = ''
    		mkdir -p $out/share/sddm/themes/sugar-dark
    		cp -r * $out/share/sddm/themes/sugar-dark/
    	'';
}
