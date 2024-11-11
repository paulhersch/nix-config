{ pkgs, lib, ... }:

{
    imports = [
        ./common.nix
    ];

    programs.river = {
        enable = true;
        extraPackages = with pkgs; [
            # ags with river module
            # (ags.override {
            #     extraPackages = [
            #         astal-river
            #     ];
            # })
            ags
            nemo-with-extensions
            foot
            gammastep
            glib
            grim
            libastal-lua
            kanshi
            networkmanagerapplet
            river-luatile
			slurp
            waybar
            wbg
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
