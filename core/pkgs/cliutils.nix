{ pkgs, ... }:

with pkgs; [
  efibootmgr
  efitools
  pciutils
  usbutils
  dnsutils
  smartmontools
  brightnessctl
  unzip
  zip
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
  lz4
] ++ [
  pkgs.unstable.neovim
]
