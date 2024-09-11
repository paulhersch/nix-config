{ pkgs, lib, ... }:

let
    astal-lua = pkgs.luajit.withPackages (p: [
        p.lgi
        p.fzy
        p.rapidjson
        pkgs.astal-lualib
    ]);
    libastal-lua = pkgs.writeScriptBin "libastal-lua" ''
        #!${astal-lua}/bin/lua
        package.path = package.path .. ";${./.}/?.lua"
        require "init"
    '';
in
{
    imports = [
        ./common.nix
    ];

    programs.river = {
        enable = true;
        extraPackages = with pkgs; [
            # ags with river module
            (ags.override {
                extraPackages = [
                    astal-river
                ];
            })
            cinnamon.nemo-with-extensions
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
