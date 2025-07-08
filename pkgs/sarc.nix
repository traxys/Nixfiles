{
  lib,
  python311,
  fetchFromGitHub,
  rstb,
}:

python311.pkgs.buildPythonApplication rec {
  pname = "sarc";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeldamods";
    repo = "sarc";
    rev = "v${version}";
    hash = "sha256-F6ra0AOd5yGZX4lWXHUO3fk5oK1hT7j1wWzZeWSbD84=";
  };

  build-system = [
    python311.pkgs.setuptools
    python311.pkgs.wheel
  ];

  nativeBuildInputs = [ python311.pkgs.pythonRelaxDepsHook ];

  dependencies = [ rstb ];

  pythonImportsCheck = [
    "sarc"
  ];

  pythonRelaxDeps = [ "oead" ];

  meta = {
    description = "Nintendo SARC archive reader and writer";
    homepage = "https://github.com/zeldamods/sarc";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sarc";
  };
}
