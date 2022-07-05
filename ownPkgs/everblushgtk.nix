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
