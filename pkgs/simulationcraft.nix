{
  simulationcraft-src,
  stdenv,
  qt5,
  cmake,
  curl,
}:
stdenv.mkDerivation {
  pname = "simulationcraft";
  version = "master";

  src = simulationcraft-src;

  buildInputs = [
    qt5.qtbase
    qt5.qtwebengine
    cmake
    curl
  ];
  nativeBuildInputs = [qt5.wrapQtAppsHook];
}
