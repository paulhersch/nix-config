{ pkgs, config, ... }:

{
	fonts.fonts = with pkgs; [
		( nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "FantasqueSansMono" ];} )
		lato
		inter
		recursive
		cascadia-code
		iosevka-comfy.comfy-motion-fixed
		iosevka-comfy.comfy-motion-duo
		#material-design-icons
		emacs-all-the-icons-fonts
		twitter-color-emoji
	];
}
