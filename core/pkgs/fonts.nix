{ pkgs, config, ... }:

{
	fonts.fonts = with pkgs; [
		( nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "FantasqueSansMono" ];} )
		lato
		inter
		iosevka-comfy.comfy-motion
		iosevka-comfy.comfy-motion-duo
		material-design-icons
		twitter-color-emoji
	];
}
