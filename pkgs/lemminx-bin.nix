{
  stdenv,
  fetchzip,
  autoPatchelfHook,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "lemminx-bin";
  version = "0.24.0";

  src = fetchzip {
    url = "https://github.com/redhat-developer/vscode-xml/releases/download/${version}/lemminx-linux.zip";
    hash = "sha256-7psi6rU7e4jN/D1CgB9Uf7NfPRHFNNiXJD5GsRk8hX8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp lemminx-linux $out/bin/lemminx-bin
  '';

  meta = with lib; {
    homepage = "https://github.com/redhat-developer/vscode-xml";
    description = "LSP for XML";
    platforms = platforms.linux;
    architectures = ["amd64"];
  };
}
