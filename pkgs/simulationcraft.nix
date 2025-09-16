{
  simulationcraft-src,
  stdenv,
  qt6,
  cmake,
  curl,
}:
stdenv.mkDerivation {
  pname = "simulationcraft";
  version = "master";

  src = simulationcraft-src;

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    cmake
    curl
  ];
  nativeBuildInputs = [ qt6.wrapQtAppsHook ];
}
