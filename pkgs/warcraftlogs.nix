{
  warcraftlogs-src,
  appimageTools,
  lib,
}:
appimageTools.wrapType2 rec {
  inherit (warcraftlogs-src) pname src version;

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
