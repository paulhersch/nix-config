{ pkgs, config, ... }:

{
	fonts.fonts = with pkgs; [
		( nerdfonts.override { fonts = [ "CascadiaCode" ];} )
		lato
		inter
		cascadia-code
		material-design-icons
		twitter-color-emoji
	];
}
