{
  pkgs,
  config,
  lib,
  ...
}:

let
  unstablepkgs = with pkgs.unstable; [
    prismlauncher
    # factorio
  ];
  stablepkgs = with pkgs; [
    polychromatic
  ];
in
{
  environment.systemPackages =
    unstablepkgs
    ++ stablepkgs
    ++ (with pkgs; [
      ryubing
      old.torzu
      pcsx2
      bottles
      lutris
      wine
      winetricks
    ]);

  programs = {
    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override { cudaSupport = true; };
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
        input-overlay
      ];
    };
    steam = {
      gamescopeSession.enable = true;
      enable = true;
      extraPackages = with pkgs; [
        gamescope
        gamemode
        mangohud
        libkrb5
        keyutils
        stdenv.cc.cc.lib
        libpng
      ];
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
    gamescope = {
      enable = true;
      # capSysNice = true;
    };
  };
  hardware = {
    # openrazer = {
    #   enable = true;
    #   users = [ "paul" "luise" ];
    # };
    graphics = {
      extraPackages = with pkgs; [
        libva
        libva-utils
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        libva-utils
      ];
      enable32Bit = true;
    };
  };
  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
