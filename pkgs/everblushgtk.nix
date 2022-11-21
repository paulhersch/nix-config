{ stdenv, pkgs, fetchFromGitHub, ... }:
let
	pname = "everblush-gtk";
	ver = "1";
in
stdenv.mkDerivation {
	name = "${pname}-${ver}";
	src = fetchFromGitHub {
		owner = "Everblush";
		repo = "gtk";
		rev = "main";
		hash = "sha256-eUVfIKlhA/LQvYOejnyuQlgG0KAv4wEE+QdvNrDq26A=";
	};
	dontBuild = true;
	preInstall = ''
		mkdir -p $out/share/themes/Everblush-gtk
	'';
	installPhase = ''
		runHook preInstall
		install -m 0644 -v $src/index.theme $out/share/themes/Everblush-gtk/
		cp -r $src/gtk-* $out/share/themes/Everblush-gtk/
	'';
}
