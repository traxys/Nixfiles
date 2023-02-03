{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "wowup-cf";
  version = "2.9.2";

  src = fetchurl {
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v${version}/WowUp-CF-${version}.AppImage";
    sha256 = "sha256-8R6H6ctmVrJgkvthyXGrp1mkthBlr08y1pYIoEkrB7w=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extractType2 {inherit pname version src;};
  in ''
  	mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/wowup-cf.desktop $out/share/applications/wowup-cf.desktop
    substituteInPlace $out/share/applications/wowup-cf.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/wowup-cf.png \
		$out/share/icons/hicolor/512x512/apps/wowup-cf.png
  '';

  meta = with lib; {
    homepage = "https://wowup.io/";
    description = "Tool to install world of warcraft addons";
    license = licenses.gpl3Plus;
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [traxys];
  };
}
