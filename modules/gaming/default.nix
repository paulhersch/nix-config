{ pkgs, config, lib, ... }:

let
  unstablepkgs = with pkgs.unstable; [
    prismlauncher
    # factorio
  ];
  stablepkgs = with pkgs; [
    polychromatic
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
        input-overlay
      ];
    })
  ];
in
{
  environment.systemPackages = unstablepkgs ++ stablepkgs;
  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          gamescope
          gamemode
          mangohud
        ];
      };
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  hardware = {
    openrazer = {
      enable = true;
      users = [ "paul" "luise" ];
    };
    graphics = {
      extraPackages = with pkgs; [ libva libva-utils ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva libva-utils ];
      enable32Bit = true;
    };
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
