{ lib
, fetchFromGitHub
, gtk-engine-murrine
, jdupes
, gdk-pixbuf # pixbuf engine for Gtk2
, gnome-themes-extra # adwaita engine for Gtk2
, librsvg # pixbuf loader for svg
, which
, sassc
, stdenv
, color-changes ? { } # refer to: https://github.com/vinceliuice/Qogir-theme/blob/master/HACKING
, theme-name ? "Qogir"
, ...
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

  installPhase = ''
    chmod 755 -R .
    # construct sed instructions to remove lines in scss 
  '' + builtins.concatStringsSep "\n" (lib.attrsets.mapAttrsToList
    (name: color: (
      "sed -i '/${name}/c\\\$${name}: ${color};' ./src/_sass/_colors.scss"
    ))
    color-changes) + ''

    cat > ./src/_sass/_tweaks.scss << EOF
$trans: 'false';
$theme: 'default';
$titlebutton: 'circle';
$background: 'default';
$window: 'default';
EOF

    # patch build and install scripts
    patchShebangs --build parse-sass.sh install.sh

    mkdir -p $out/share/themes
    ./parse-sass.sh
    ./install.sh -l -c light -n ${theme-name} -d $out/share/themes

    mkdir -p $out/share/doc/qogir-theme
    cp -a src/firefox $out/share/doc/qogir-theme
    rm $out/share/themes/*/{AUTHORS,COPYING}
    jdupes --quiet --link-soft --recurse $out/share
  '';
}

