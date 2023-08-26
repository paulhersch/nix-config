{ pkgs }:
# all of this is copied from https://github.com/Misterio77/nix-colors/blob/main/lib/contrib/gtk-theme.nix
let
  rendersvg = pkgs.runCommand "rendersvg" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.resvg}/bin/resvg $out/bin/rendersvg
  '';
  theme = import ../globals/colors.nix {};
in
pkgs.stdenv.mkDerivation rec {
  name = "generated-materia-theme";
  src = pkgs.fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    rev = "76cac96ca7fe45dc9e5b9822b0fbb5f4cad47984";
    sha256 = "sha256-0eCAfm/MWXv6BbCl2vbVbvgv8DiUH09TAUhoKq7Ow0k=";
  };
  buildInputs = with pkgs; [
    sassc
    bc
    which
    rendersvg
    meson
    ninja
    nodePackages.sass
    gtk4.dev
    optipng
  ];
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    HOME=/build
    chmod 777 -R .
    patchShebangs .
    mkdir -p $out/share/themes
    mkdir bin
    sed -e 's/handle-horz-.*//' -e 's/handle-vert-.*//' -i ./src/gtk-2.0/assets.txt

    cat > /build/gtk-colors << EOF
      BTN_BG=${theme.dbg}
      BTN_FG=${theme.c7}
      FG=${theme.fg}
      BG=${theme.bg}
      HDR_BTN_BG=${theme.lbg}
      HDR_BTN_FG=${theme.c5}
      ACCENT_BG=${theme.c12}
      ACCENT_FG=${theme.fg}
      HDR_FG=${theme.c5}
      HDR_BG=${theme.lbg}
      MATERIA_SURFACE=${theme.dbg}
      MATERIA_VIEW=${theme.dbg}
      MENU_BG=${theme.lbg}
      MENU_FG=${theme.c6}
      SEL_BG=${theme.c12}
      SEL_FG=${theme.fg}
      TXT_BG=${theme.c2}
      TXT_FG=${theme.c6}
      WM_BORDER_FOCUS=${theme.dbg}
      WM_BORDER_UNFOCUS=${theme.bg}
      UNITY_DEFAULT_LAUNCHER_STYLE=False
      NAME=Materia-custom
      MATERIA_STYLE_COMPACT=True
    EOF

    echo "Changing colours:"
    ./change_color.sh -o Materia-custom /build/gtk-colors -i False -t "$out/share/themes"
    chmod 555 -R .
  '';
}
