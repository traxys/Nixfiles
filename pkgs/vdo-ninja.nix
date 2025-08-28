{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "vdo-ninja";
  version = "28.0";

  src = fetchFromGitHub {
    owner = "steveseguin";
    repo = "vdo.ninja";
    rev = "v${version}";
    hash = "sha256-XkZ+ImjeLk+1Byl+ZFZ1l1Zy8vonfKK1GWhq8q7eDDo=";
  };

  installPhase = ''
    mkdir -p $out/share/www
    mv * $out/share/www
  '';

  meta = {
    description = "VDO.Ninja is a powerful tool that lets you bring remote video feeds into OBS or other studio software via WebRTC";
    homepage = "https://github.com/steveseguin/vdo.ninja";
    license = lib.licenses.agpl3Plus; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ traxys ];
    mainProgram = "vdo-ninja";
    platforms = lib.platforms.all;
  };
}
