{
  stdenv,
  proton-ge-src,
}:
stdenv.mkDerivation {
  inherit (proton-ge-src) pname src version;

  nativeBuildInputs = [];

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';
}
