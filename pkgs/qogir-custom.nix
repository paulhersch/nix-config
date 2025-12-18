{
  lib,
  fetchFromGitHub,
  gtk-engine-murrine,
  jdupes,
  gdk-pixbuf,
  # pixbuf engine for Gtk2
  gnome-themes-extra,
  # adwaita engine for Gtk2
  librsvg,
  # pixbuf loader for svg
  which,
  sassc,
  stdenv,
  color-changes ? { },
  # refer to: https://github.com/vinceliuice/Qogir-theme/blob/master/HACKING
  color-variant ? "",
  theme-name ? "Qogir",
  ...
}:

stdenv.mkDerivation {
  name = "custom-qogir-theme";
  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Qogir-theme";
    rev = "551e6765239e7466fb4d9db706634a7f737462d8";
    hash = "sha256-k37VbrlFroI1aPNhivL4wnk5auUYh75R53wKC0brQ7E=";
  };

  nativeBuildInputs = [
    jdupes
    sassc
    which
  ];

  buildInputs = [
    gdk-pixbuf # pixbuf engine for Gtk2
    gnome-themes-extra # adwaita engine for Gtk2
    librsvg # pixbuf loader for svg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine # murrine engine for Gtk2
  ];

  installPhase =
    let
      replacements = builtins.concatStringsSep "\n" (
        lib.attrsets.mapAttrsToList (
          # construct sed instructions to change lines in scss
          # match beginning of the word that is to be replaced and add in the color
          name: color: ("sed -i '/^\\\$${name}:/c\\\$${name}: ${color};' ./src/_sass/_colors.scss")
        ) color-changes
      );
    in
    ''
      chmod 755 -R .

      ${replacements}
      # remove the conditionals in colors that still change the color
      sed -i '/^@if/d' ./src/_sass/_colors.scss

      # patch build and install scripts
      patchShebangs --build parse-sass.sh install.sh

      mkdir -p $out/share/themes
      SRC_DIR=./src ./parse-sass.sh
      ./install.sh --theme default --color ${color-variant} --name ${theme-name} --dest $out/share/themes

      mkdir -p $out/share/doc/qogir-theme
      cp -a src/firefox $out/share/doc/qogir-theme
      rm $out/share/themes/*/{AUTHORS,COPYING}
      jdupes --quiet --link-soft --recurse $out/share
    '';
}
