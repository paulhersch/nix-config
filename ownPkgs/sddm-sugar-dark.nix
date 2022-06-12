{ stdenv, pkgs, fetchurl, ... }:
let
	pname = "sddm-sugar-dark";
	ver = "1.2";
in
stdenv.mkDerivation {
	name = "${pname}-${ver}";
	src = fetchurl {
		url = "https://github.com/MarianArlt/sddm-sugar-dark/archive/master.tar.gz";
		sha256 = "103c18aebd3109c897f5f6e5b8814ab4887468c487a8b2f7a17cf8b33c06b38e";
	};

#	depsBuildTarget = with pkgs.libsForQt5.qt5; [
#		qtquickcontrols2
#		qtsvg
#	];

	buildPhase ='' ''; #no build phase needed

	installPhase = ''
		mkdir -p $out/share/sddm/themes/sugar-dark
		cp -r * $out/share/sddm/themes/sugar-dark/
	'';
}
#environment.systemPackages = [
#	pkgs.libsForQt5.qt5.qtgraphicaleffects
#];
