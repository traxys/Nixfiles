{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "bars-to-bwav";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jackz314";
    repo = "bars-to-bwav";
    rev = version;
    hash = "sha256-p2VJ1GtV6nk+hWn6Jd/tlIYn7+ZRHErMSnM/sV0ceHI=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bars-to-bwav $out/bin
  '';

  meta = {
    description = "Extracts BWAV files from BARS files (usually used as sound containers in Nintendo Switch games";
    homepage = "https://github.com/jackz314/bars-to-bwav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "bars-to-bwav";
    platforms = lib.platforms.all;
  };
}
