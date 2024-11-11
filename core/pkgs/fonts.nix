{ pkgs, config, ... }:

{
	fonts.packages = with pkgs; [
		( nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "FantasqueSansMono" ];} )
		lato
		inter
		iosevka-comfy.comfy-motion-fixed
		iosevka-comfy.comfy-motion-duo
		material-design-icons
		twitter-color-emoji
	];
}
