{ pkgs, lib, ... }:

{
    imports = [
        ./common.nix
    ];

    programs.river = {
        enable = true;
        extraPackages = with pkgs; [
            ags
            nemo-with-extensions
            foot
            gammastep
            glib
            grim
            libastal-lua
            astal
            kanshi
            networkmanagerapplet
            river-luatile
			slurp
            swww
            waybar
            wl-clipboard
            wlr-randr
        ];
    };

    xdg = {
        terminal-exec.settings = {
            river = [
                "org.codeberg.dnkl.foot"
            ];
        };
        portal = {
            enable = true;
            wlr = {
                enable = true;
            };
            config.river = {
                default = [ "wlr" "gtk" ];
            };
        };
    };
}
