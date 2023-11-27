{ pkgs, ... }:

with pkgs; [
	efibootmgr
	efitools
	pciutils
	usbutils
	smartmontools
	brightnessctl
	unzip
	zip
	gammastep
	pamixer
	patchelf
	playerctl
	btop
	tree
	git
	wget 
	android-tools
	partclone
	nsnake
	cifs-utils
] ++ [
	pkgs.unstable.neovim
]
