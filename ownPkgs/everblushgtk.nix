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
		sha256 = "1fmjv898j10j64jrj1ddpp4xpf76awnvakjwmahqhs9wd114x3xs";
	};
#	nativeBuildInputs = with pkgs.nodePackages; [
#		sass
#	];
#	preBuild = ''
#		mkdir -p $out/share/themes/Everblush-gtk/gtk-3.0
#	'';
#	buildPhase = ''
#		runHook preBuild
#		sass $src/scss/gtk-3.0/gtk.scss $out/share/themes/Everblush-gtk/gtk-3.0/gtk.css
#	'';
	dontBuild = true;
	preInstall = ''
		mkdir -p $out/share/themes/Everblush-gtk
	'';
	installPhase = ''
		runHook preInstall
		cp -r $src/* $out/share/themes/Everblush-gtk/
	'';
}
