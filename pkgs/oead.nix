{
  lib,
  python3,
  fetchFromGitHub,
  cmake,
  ninja,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "oead";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeldamods";
    repo = "oead";
    rev = "v${version}";
    hash = "sha256-lpXDN0gJ3mBO0UgH7J473qkvwjN2Tt6dP1RjDbeskOY=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    python3.pkgs.scikit-build-core
    python3.pkgs.setuptools-scm
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
