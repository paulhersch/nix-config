{
  atkmm,
  autoPatchelfHook,
  cairo,
  fetchFromGitHub,
  fpc,
  gdk-pixbuf,
  gtk2,
  lazarus-qt6,
  lib,
  libX11,
  pango,
  qt6Packages,
  stdenv,
}:

stdenv.mkDerivation {
  src = fetchFromGitHub {
    owner = "danielfppps";
    repo = "hydrobuddy";
    rev = "a1e63b32dcee9f92e34c9c281e090820dfc49def";
    hash = "sha256-QZXVQgGbKiIFHzKY2jo/pahnjyl5XZKL0zfoT6iPlGg=";
  };

  pname = "hydrobuddy";
  version = "v1.100";

  buildInputs = [
    libX11
    qt6Packages.qtbase
    gtk2
    gdk-pixbuf
    pango
    cairo
    atkmm
  ];

  nativeBuildInputs = [
    lazarus-qt6
    fpc
    qt6Packages.wrapQtAppsHook
    autoPatchelfHook
  ];

  buildPhase = ''
    runHook preBuild
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B hydrobuddy.lpi
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstallPhase
    mkdir -p $out/bin
    cp hydrobuddy $out/bin
    runHook postInstallPhase
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --suffix PATH : ${
        lib.makeBinPath [
          gtk2
          gdk-pixbuf
          pango
          cairo
          atkmm
        ]
      })
  '';
}
