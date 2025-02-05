{ pkgs, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "plymouth-dotlock";
  version = "1.1";
  src = fetchFromGitHub {
    owner = "vikashraghavan";
    repo = "dotLock";
    rev = "728ab3e9220bc631548287e80b2fc20f966c356c";
    hash = "sha256-iMUfGOefurRsJfYPhtcLb1QGGv/pkqt3QreKUPa+UKE=";
  };
  dontBuild = true;
  installPhase = ''
    		mkdir -p $out/share/plymouth/themes/
    		cp -r * dotLock $out/share/plymouth/themes
    	'';
}
