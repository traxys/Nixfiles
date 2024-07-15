{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "cura-appimage";
  version = "5.7.1";

  src = fetchurl {
    url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
    sha256 = "sha256-LZMD0fo8TSlDEJspvTka724lYq5EgrOlDkwMktXqATw=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    # sh
    ''
      ls -la ${appimageContents}
      install -m 444 -D ${appimageContents}/com.ultimaker.cura.desktop $out/share/applications/com.ultimaker.cura.desktop
      substituteInPlace $out/share/applications/com.ultimaker.cura.desktop --replace-fail 'Exec=UltiMaker-Cura' 'Exec=${pname}'
      install -m 444 -D ${appimageContents}/cura-icon.png \
        $out/share/icons/hicolor/256x256/apps/cura-icon.png
    '';

  meta = with lib; {
    homepage = "https://github.com/Ultimaker/Cura";
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ traxys ];
  };
}
