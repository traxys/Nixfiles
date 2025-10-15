{
  lib,
  python311,
  fetchFromGitHub,
  cmake,
}:

python311.pkgs.buildPythonApplication rec {
  pname = "oead";
  version = "1.2.9-4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeldamods";
    repo = "oead";
    rev = "v${version}";
    hash = "sha256-rBzXs5OaSssCjakOmGRsvL0OSq1EApllRN59lFaRNrU=";
    fetchSubmodules = true;
  };

  CMAKE_POLICY_VERSION_MINIMUM = "3.5";

  dontUseCmakeConfigure = true;

  build-system = [
    python311.pkgs.setuptools
    python311.pkgs.wheel
    cmake
  ];

  pythonImportsCheck = [
    "oead"
  ];

  meta = {
    description = "Library for recent Nintendo EAD formats in first-party games";
    homepage = "https://github.com/zeldamods/oead";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "oead";
  };
}
