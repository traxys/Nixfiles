{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pymsbt";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p1gyy";
    repo = "pymsbt";
    rev = "v${version}";
    hash = "sha256-LP+9SKbvDnjd5jxZYUKIqyJUp96Ee71ndkoQ6oceoJg=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "pymsbt"
  ];

  meta = {
    description = "A python library for parsing and editing .msbt files";
    homepage = "https://github.com/p1gyy/pymsbt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
