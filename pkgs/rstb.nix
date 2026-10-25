{
  lib,
  python3,
  fetchFromGitHub,
  oead,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rstb";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeldamods";
    repo = "rstb";
    rev = "v${version}";
    hash = "sha256-wd+kR+bQqaD9VNMSO3SNkA6uUe/6SFje8VmhbkJD0xg=";
  };

  postPatch = ''
    rm versioneer.py
  '';

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = [
    oead
    python3.pkgs.versioneer
  ];

  pythonRelaxDeps = [ "oead" ];

  pythonImportsCheck = [
    "rstb"
  ];

  meta = {
    description = "Utilities to modify Breath of the Wild's Resource Size Table (RSTB";
    homepage = "https://github.com/zeldamods/rstb";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "rstb";
  };
}
