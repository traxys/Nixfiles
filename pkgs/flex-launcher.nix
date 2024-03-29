{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_ttf,
}:
stdenv.mkDerivation rec {
  pname = "flex-launcher";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = "flex-launcher";
    rev = "v${version}";
    hash = "sha256-/W6q7wX7QZ1uz+eXef5ST61nt8Z8Ybc1Lg8iaJPXguQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2_ttf
    SDL2_image
    SDL2
  ];

  meta = with lib; {
    description = "A customizable HTPC application launcher for Windows and Linux";
    homepage = "https://github.com/complexlogic/flex-launcher";
    changelog = "https://github.com/complexlogic/flex-launcher/blob/${src.rev}/CHANGELOG";
    license = licenses.unlicense;
    maintainers = with maintainers; [traxys];
    mainProgram = "flex-launcher";
    platforms = platforms.all;
  };
}
