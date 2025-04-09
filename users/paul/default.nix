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
      "dialout" # ESP32 dev
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
        conf = import ./confs/config.def.h.nix { };
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
      pandoc

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
        # ".config/wezterm/wezterm.lua".text = import ./confs/wez.nix { inherit theme; };
        # ".config/alacritty/alacritty.toml".text = import ./confs/alacritty.nix { inherit theme; };
        ".config/sway/config".text = import ./confs/sway/config.nix { inherit pkgs; inherit theme; };
        ".config/fontconfig/conf.d/99-alias-main.conf".text = import ./confs/fontconf.nix { };
        ".zshenv".text = "";
        ".config/river/bordercolors" = {
          text = import ./confs/river/borders.nix { inherit theme; };
          executable = true;
        };
      };
      sessionVariables = {
        ZK_NOTEBOOK_DIR = "$HOME/Dokumente/Uni/zk";
      };
    };

    services = {
      mako = {
        # only useful with niri, got a ui for sway (TODO tho)
        # enable = config.programs.niri.enable;
        # libastal is annoying asf
        enable = true;
        anchor = "top-center";
        width = 600;
        backgroundColor = "#${theme.bg}";
        textColor = "#${theme.fg}";
        borderColor = "#${theme.dbg}";
        defaultTimeout = 5000;
        font = "Iosevka Comfy Motion Duo 12";
        format = "<span style=\"italic\" size=\"large\">%s</span>\\n%b";
        markup = true;
        iconPath = "${config.home-manager.users.paul.gtk.iconTheme.package}/share/icons/${config.home-manager.users.paul.gtk.iconTheme.name}";
      };
      kanshi = {
        enable = true;
        settings = [
          { include = "~/.config/kanshi.conf"; }
        ];
        systemdTarget = if config.programs.niri.enable then "niri.service" else
        (
          "sway-session.target" # river also executes that i think
        );
      };
      gammastep = {
        enable = true;
        provider = "manual";
        # dawnTime = "7:00-8:30";
        # duskTime = "16:45-17:30";
        latitude = 51.0;
        longitude = 12.0;
        temperature = {
          day = 5200;
          night = 4700;
        };
        settings.general = {
          "brightness-day" = 1.0;
          "brightness-night" = 0.9;
        };
        tray = true;
      };
    };

    programs = {
      kitty = {
        enable = true;
        settings = {
          font_family = "family=\"Iosevka Comfy Motion Fixed\" style=Medium";
          bold_font = "family=\"Iosevka Comfy Motion Fixed\" style=Bold";
          italic_font = "family=\"Iosevka Comfy Motion Fixed\" style=\"Medium Italic\"";
          bold_italic_font = "family=\"Iosevka Comfy Motion Fixed\" style=\"Bold Italic\"";
          font_size = 12;
          symbol_map = "U+E0A0-U+E0D7,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B5,U+E700-U+E7C5,U+EA60-U+EC1E,U+ED00-U+EFCE,U+F000-U+F375,U+F400-U+F533,U+276C-U+2771,U+23FB-U+23FE,U+2B58 Symbols Nerd Font Mono\nsymbol_map U+1FA70-U+E007F,U+1F90C-U+1F9FF,U+1F7E0-U+1F7F0,U+1F680-U+1F6FC,U+1F170-U+1F64F,U+1F0CF,U+1F004,U+3030-U+3299,U+2B05-U+2B55,U+2795-U+2935,U+25AA-U+2764,U+23CF-U+23FA,U+203C-U+2328 Twitter Color Emoji";
          disable_ligatures = "always";
          cursor = "#${theme.c0}";
          window_padding_width = "7";
          foreground = "#${theme.fg}";
          background = "#${theme.bg}";
          selection_background = "#${theme.dbg}";
          color0 = "#${theme.c0}";
          color1 = "#${theme.c1}";
          color2 = "#${theme.c2}";
          color3 = "#${theme.c3}";
          color4 = "#${theme.c4}";
          color5 = "#${theme.c5}";
          color6 = "#${theme.c6}";
          color7 = "#${theme.c7}";
          color8 = "#${theme.c8}";
          color9 = "#${theme.c9}";
          color10 = "#${theme.c10}";
          color11 = "#${theme.c11}";
          color12 = "#${theme.c12}";
          color13 = "#${theme.c13}";
          color14 = "#${theme.c14}";
          color15 = "#${theme.c15}";
        };
      };
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
      autorandr = import ./autorandrhm.nix { };
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
