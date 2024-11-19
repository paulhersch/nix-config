{ config
, lib
, pkgs
, stdenv
, home-manager
, ...
}:
let
    theme = import ../../globals/colors.nix { };
    py_pkgs = (pkgs.python3.withPackages (p: with p; [
        python-lsp-server
        python-lsp-ruff
        python-lsp-black
        pylsp-mypy
        jupytext
        rope
        pylatexenc
    ]));
in
{
    imports = [
        #./services/mopidy.nix
    ];
    users.users.paul = {
        createHome = true;
        description = "Paul Schneider";
        isNormalUser = true;
        extraGroups = [
            "messagebus"
            "networkmanager"
            "libvirtd"
            "video"
            "input"
            "docker"
            "plugdev"
            "wheel" # for cups
        ];
        packages = with pkgs;[
            qmk
            chromium
            firefox
            steam-run
            element-desktop
            (pkgs.callPackage ../../pkgs/st-flex.nix {
                addPatches = [
                    "anysize"
                    "xresources"
                    "boxdraw"
                    "bold is not bright"
                    "csi 22 23"
                    "columns"
                    "font2"
                    "hidecursor"
                    "ligatures"
                    "netwmicon"
                    "sixel"
                    "scrollback"
                    "scrollback mouse"
                    "scrollback mouse altscreen"
                    "sync"
                    "themed cursor"
                    "undercurl"
                    "wide glyphs"
                    "vertcenter"
                ];
                conf = import ./confs/config.def.h.nix {};
                harfbuzzFeatures = [ "dlig" ];
            })

            luaPackages.lua
            ghc
            rustup
            gcc
            gnumake
            cargo
            texlive.combined.scheme-full
            anydesk
            pdfpc

            # finally, no Java :))))
            # keeping this in here in case i need to do the cringe again
            # jetbrains.idea-community
            dbeaver-bin
            # prismlauncher
            # openjdk
            # maven
            # psqlcli
            # postgresql_15

            ## neovim + deps
            unstable.neovide
            # python and different python stuffs for everything
            py_pkgs
            # debuggers
            gdb

            # annoying ass work software
            # citrix_workspace
            # instead i ask the ppl provisioning boxes to give me a static IP + RDP
            # and then i use remmina to access them, citrix simply doesnt fucking
            # connect to anything without giving me any clues about whats going on
            remmina
        ];
    };
    home-manager.users.paul = {
        home = { stateVersion = "22.05"; };
        nixpkgs.config.allowUnfree = true;
        
        gtk = import ./gtk.nix { inherit pkgs; };
        xresources.extraConfig = import ./confs/xresources.nix { inherit theme; };
        
        home = {
            file = {
                ".config/wezterm/wezterm.lua".text = import ./confs/wez.nix { inherit theme; };
                ".config/alacritty/alacritty.toml".text = import ./confs/alacritty.nix { inherit theme; };
                ".config/sway/config".text = import ./confs/sway/config.nix { inherit pkgs; inherit theme; };
                ".config/fontconfig/conf.d/99-alias-main.conf".text = import ./confs/fontconf.nix {};
                ".zshenv".text = "";
                ".config/river/bordercolors" = {
                    text = import ./confs/river/borders.nix { inherit theme; };
                    executable = true;
                };
            };
            sessionVariables = {
                ZK_NOTEBOOK_DIR="$HOME/Dokumente/Uni/zk";
            };
        };

        programs = {
            neovim = {
                enable = true;
                package = pkgs.unstable.neovim-unwrapped;
                vimAlias = true;
                withNodeJs = true; # :(
                extraLuaPackages = p: with p; [
                    luarocks
                    # molten-nvim
                    magick
                ];
                extraPython3Packages = ps: with ps; [
                    # molten-nvim
                    cairosvg
                    jupyter-client
                    kaleido
                    nbformat
                    pillow
                    plotly
                    pnglatex
                    pynvim
                    pyperclip
                    requests
                    websocket-client
                ];
                extraPackages = with pkgs; [
                    nodejs
                    tree-sitter
                    luajitPackages.luarocks
                    # molten-nvim
                    imagemagick
                    ueberzugpp
                    # telescope
                    ripgrep
                    fd
                    zk
                    # language servers
                    texlab
                    ltex-ls
                    haskell-language-server
                    sumneko-lua-language-server
                    omnisharp-roslyn
                    quick-lint-js
                    nodePackages.typescript-language-server
                    nodePackages.bash-language-server
                    shellcheck
                    nil
                    ccls
                ];
            };
            autorandr = import ./autorandrhm.nix {};
            # not on X any more
            direnv = {
                enable = true;
                enableZshIntegration = true;
                nix-direnv.enable = true;
            };
            zsh.enable = true;
            zathura = {
                enable = true;
                extraConfig = with theme;''
                    set recolor
                    set recolor-lightcolor "#${bg}"
                    set recolor-darkcolor "#${fg}"
                    set default-bg "#${bg}"
                    set guioptions vhs
                    set adjust-open width
                '';
            };
            alacritty.enable = true;
            tofi = {
                enable = true;
                settings = {
                    font = "Iosevka Comfy Motion Duo";
                    font-size = 15;
                    text-color = "#${theme.fg}";
                    placeholder-color = "#${theme.c0}";
                    selection-match-color = "#${theme.c12}";
                    selection-color = "#${theme.fg}";
                    selection-background = "#${theme.dbg}";
                    text-cursor-style = "bar";
                    prompt-text = "> ";
                    prompt-padding = 5;
                    padding-bottom = 20;
                    padding-top = 20;
                    padding-left = 20;
                    padding-right = 20;
                    placeholder-text = "search";
                    num-results = 10;
                    result-spacing = 25;
                    horizontal = false;
                    background-color = "#${theme.bg}";
                    outline-width = 0;
                    border-width = 2;
                    border-color = "#${theme.c12}";
                    hide-cursor = true;
                    text-cursor = true;
                    history = false;
                    require-match = true;
                    drun-launch = true;
                    # matching-algorithm = "fuzzy";
                };
            };
            foot = {
                enable = true;
                server.enable = true;
                settings = {
                    main = {
                        term = "xterm-256color";
                        font = "Iosevka With Fallback:size=12";
                        pad = "10x10";
                        dpi-aware = "no";
                    };
                    tweak = {
                        overflowing-glyphs = "yes";
                    };
                    bell = {
                        urgent = "no";
                        notify = "no";
                    };
                    scrollback = {
                        lines = 10000;
                    };
                    cursor = {
                        style = "beam";
                        blink = "yes";
                    };
                    colors = with theme; {
                        foreground = "${fg}";
                        background = "${bg}";
                        selection-background = "${llbg}";
                        regular0 = "${c0}";
                        regular1 = "${c1}";
                        regular2 = "${c2}";
                        regular3 = "${c3}";
                        regular4 = "${c4}";
                        regular5 = "${c5}";
                        regular6 = "${c6}";
                        regular7 = "${c7}";
                        bright0 = "${c8}";
                        bright1 = "${c9}";
                        bright2 = "${c10}";
                        bright3 = "${c11}";
                        bright4 = "${c12}";
                        bright5 = "${c13}";
                        bright6 = "${c14}";
                        bright7 = "${c15}";
                    };
                };
            };
        };
    };
}
