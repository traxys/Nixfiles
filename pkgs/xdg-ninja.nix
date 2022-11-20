{
  xdg-ninja-src,
  lib,
  stdenv,
  bash,
  jq,
  glow,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "xdg-ninja";
  version = "0.1";
  src = xdg-ninja-src;
  installPhase = ''
    mkdir -p $out/bin
    cp xdg-ninja.sh $out/bin
    cp -r programs $out/bin
    wrapProgram $out/bin/xdg-ninja.sh \
      --prefix PATH : ${lib.makeBinPath [bash jq glow]}
  '';
  buildInputs = [jq glow bash];
  nativeBuildInputs = [makeWrapper];
}
