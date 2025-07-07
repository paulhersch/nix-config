{ pkgs, config, ... }:

{
  fonts.packages = with pkgs; [
    lato
    inter
    # iosevka-comfy.comfy-motion-fixed
    # iosevka-comfy.comfy-motion-duo
    aporetic
    material-design-icons
    twitter-color-emoji
  ] ++ (with pkgs.nerd-fonts; [
    symbols-only
    fantasque-sans-mono
    iosevka
  ]);
}
