{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "WeakAuras-Companion";
  version = "5.2.4";

  src = fetchurl {
    url = "https://github.com/WeakAuras/WeakAuras-Companion/releases/download/v${version}/WeakAuras-Companion-${version}.AppImage";
    sha256 = "sha256-r+XwfjrL8QBV+malPj9r4aDVTeNAvsLdBfEIltGmdGU=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -m 444 -D ${appimageContents}/weakauras-companion.desktop $out/share/applications/weakauras-companion.desktop
      substituteInPlace $out/share/applications/weakauras-companion.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/weakauras-companion.png \
        $out/share/icons/hicolor/512x512/apps/weakauras-companion.png
    '';

  meta = with lib; {
    homepage = "https://weakauras.wtf/";
    description = " A cross-platform application built to provide the missing link between Wago.io and World of Warcraft ";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ traxys ];
  };
}
