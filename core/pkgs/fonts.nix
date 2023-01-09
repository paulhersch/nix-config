{ pkgs, config, ... }:

{
	fonts.fonts = with pkgs; [
		( nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "FantasqueSansMono" ];} )
		lato
		inter
		recursive
		cascadia-code
		iosevka
		material-design-icons
		twitter-color-emoji
	];
}
