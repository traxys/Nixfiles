{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "proton-ge";
  version = "8-3";

  src = fetchFromGitHub {
    owner = "GloriousEggroll";
    repo = "proton-ge-custom";
    rev = "refs/tags/GE-Proton${version}";
    hash = "sha256-ma+f+UrKrXluPAvv7v5x/X22eZJsS4sen2x5EVtRZ5M=";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';
}
