{ pkgs, ... }:

{

    imports = [
        ./common.nix
    ];

    programs.river = {
        enable = true;
        extraPackages = with pkgs; [
			slurp
            cinnamon.nemo-with-extensions
            foot
            gammastep
            glib
            grim
            kanshi
            networkmanagerapplet
            river-luatile
            waybar
            wbg
            wl-clipboard
            wlr-randr
            wofi
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
