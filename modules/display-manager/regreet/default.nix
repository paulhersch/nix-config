{ ... }:

{
    services.greetd.enable = true;
    programs.regreet = {
        enable = true;
        cageArgs = [ "-m" "last" ];
        settings = {
            background = {
                path = "/etc/nixos/modules/display-manager/greetd/gtkgreet/bg.jpg";
                fit = "Cover";
            };
            GTK = {
                cursor_theme_name = "Phinger Cursors";
                font_name = "Iosevka Comfy Motion Duo 11";
                icon_theme_name = "Papirus-Light";
                theme_name = "Materia-custom";
            };
        };
    };
}
