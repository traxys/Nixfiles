{
  stdenv,
  lib,
  python3,
  bitwarden-cli,
  makeWrapper,
  ...
}:
stdenv.mkDerivation {
  pname = "hbw";
  version = "0.1";
  src = ./hbw.py;

  buildInputs = [
    (python3.withPackages (ps: with ps; [pyotp]))
    bitwarden-cli
    makeWrapper
  ];

  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/hbw
    wrapProgram $out/bin/hbw --prefix PATH : ${lib.makeBinPath [bitwarden-cli]}
  '';
}
