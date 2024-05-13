{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "warcraftlogs";
  version = "8.5.1";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v${version}/warcraftlogs-v${version}.AppImage";
    hash = "sha256-jShv1FVOzEMThS7dpWCJp1Eu8exETzJ8wTVz1DZ5xE4=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}-${version}'
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/${pname}.png \
        $out/share/icons/hicolor/0x0/apps/${pname}.png
    '';

  meta = with lib; {
    homepage = "https://www.warcraftlogs.com/";
    description = "Tool to upload world of warcraft combat logs";
    #license = licenses.unfree;
    license = licenses.mit; # workaround because unfree is tedious...
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ traxys ];
  };
}
