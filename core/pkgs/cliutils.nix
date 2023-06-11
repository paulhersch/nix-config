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
	btop
	tree
	git
	wget 
	android-tools
] ++ [
	pkgs.unstable.neovim
]
