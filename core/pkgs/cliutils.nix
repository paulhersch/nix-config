{ pkgs, ... }:

with pkgs; [
	efibootmgr
	efitools
	pciutils
	usbutils
	smartmontools
	brightnessctl
	unzip
	gammastep
	pamixer
	patchelf
	playerctl
	bpytop
	tree
	git
	wget 
	android-tools
] ++ [
	pkgs.unstable.neovim
]
