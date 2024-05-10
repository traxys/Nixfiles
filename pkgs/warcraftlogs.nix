{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "warcraftlogs";
  version = "6.0.2";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v${version}/Warcraft-Logs-Uploader-${version}.AppImage";
    hash = "sha256-b1Lt8ssL+Isd/Twv6ef3AK4/BkxWA/TtleameONo/2Q=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extractType2 {inherit pname version src;};
  in ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop --replace 'Exec=AppRun' 'Exec=${pname}-${version}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/${pname}.png \
      $out/share/icons/hicolor/256x256/apps/${pname}png
  '';

  meta = with lib; {
    homepage = "https://www.warcraftlogs.com/";
    description = "Tool to upload world of warcraft combat logs";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [traxys];
  };
}
