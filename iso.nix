{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  nixpkgs.overlays = [
    (builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
  ];
in
{
  imports = [
    ## installer available
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./modules/x11/awesome.nix
    ./core/zsh
  ];
  environment.systemPackages =
    (import ./core/pkgs/cliutils.nix { pkgs = pkgs; })
    ++ (import ./core/pkgs/basic.nix { pkgs = pkgs; unstable = unstable; })
    ++ [ pkgs.gparted ];

  isoImage.edition = "custom";
  # autologin via greetd
  services.xserver = {
    displayManager = {
      autoLogin = {
        user = "nixos";
        enable = true;
      };
      lightdm.enable = true;
      defaultSession = "installer";
      session = [{
        name = "installer";
        manage = "desktop";
        start = ''
          					${pkgs.awesome-git}/bin/awesome &
          					dbus-launch --exit-with-x11 ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
          				'';
      }];
    };
  };
}
