{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "proton-ge";
  version = "9-4";

  src = fetchFromGitHub {
    owner = "GloriousEggroll";
    repo = "proton-ge-custom";
    rev = "refs/tags/GE-Proton${version}";
    hash = "sha256-tg+ElIoPhchedHwofRArZ0ds9xF1LSrIFTBxoFm4btg=";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';
}
