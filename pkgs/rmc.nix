{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rmc";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ricklupton";
    repo = "rmc";
    rev = "v${version}";
    hash = "sha256-R6sS7/yqMuTxjlYLVir5bvZF2SRogp5729nLUQaMFjY=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = with python3.pkgs; [
    click
    rmscene
  ];

  pythonImportsCheck = [
    "rmc"
  ];

  meta = {
    description = "Convert to/from v6 .rm files from the reMarkable tablet";
    homepage = "https://github.com/ricklupton/rmc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "rmc";
  };
}
