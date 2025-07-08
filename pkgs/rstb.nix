{
  lib,
  python311,
  fetchFromGitHub,
  oead,
}:

python311.pkgs.buildPythonApplication rec {
  pname = "rstb";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeldamods";
    repo = "rstb";
    rev = "v${version}";
    hash = "sha256-wd+kR+bQqaD9VNMSO3SNkA6uUe/6SFje8VmhbkJD0xg=";
  };

  nativeBuildInputs = [ python311.pkgs.pythonRelaxDepsHook ];

  build-system = [
    python311.pkgs.setuptools
    python311.pkgs.wheel
  ];

  dependencies = [ oead ];

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
