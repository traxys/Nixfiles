{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ctcache";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matus-chochlik";
    repo = "ctcache";
    tag = finalAttrs.version;
    hash = "sha256-HjinmEIyFtj99xuI5DahHNNR+Lrghb1IBCpY5lmS08A=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    flask
    requests
  ];

  optional-dependencies = with python3.pkgs; {
    server = [
      gevent
      matplotlib
      wsgiserver
    ];
    tools = [
      matplotlib
    ];
  };

  pythonImportsCheck = [
    "ctcache"
  ];

  meta = {
    description = "Cache for clang-tidy static analysis results";
    homepage = "https://github.com/matus-chochlik/ctcache";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ctcache";
  };
})
