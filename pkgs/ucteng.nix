{
  fetchzip,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "ucteng";
  version = "2009-12-14";

  src = fetchzip {
    url = "https://sourceforge.net/projects/freetengwar/files/TengwarKeylayout/TengwarKeylayout-linux.${version}.tar.gz";
    hash = "sha256-SlbnGc1eESoEWNmcFTSy6oZCAsSoH6yLr7qFk/7H61c=";
  };

  installPhase = ''
    cp $src/ucteng $out
  '';
}
