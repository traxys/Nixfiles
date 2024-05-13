{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtest,
  curl,
  nlohmann_json,
  libarchive,
  libuuid,
  libpkgconf,
  libunwind,
  python3,
  tomlplusplus,
}:
let
  ada = fetchFromGitHub {
    owner = "ada-url";
    repo = "ada";
    rev = "refs/tags/v2.7.4";
    hash = "sha256-V5LwL03x7/a9Lvg1gPvgGipo7IICU7xyO2D3GqP6Lbw=";
  };

  tsVersion = "0.20.8";

  tree-sitter = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "refs/tags/v${tsVersion}";
    hash = "sha256-278zU5CLNOwphGBUa4cGwjBqRJ87dhHMzFirZB09gYM=";
  };

  tree-sitter-meson = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "tree-sitter-meson";
    rev = "09665fa";
    hash = "sha256-ice2NdK1/U3NylIQDnNCN41rK/G6uqFOX+OeNf3zm18=";
  };

  tree-sitter-ini = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "tree-sitter-ini";
    rev = "20aa563";
    hash = "sha256-1hHjtghBIf7lOPpupT1pUCZQCnzUi4Qt/yHSCdjMhCU=";
  };

  sha256 = fetchFromGitHub {
    owner = "amosnier";
    repo = "sha-2";
    rev = "49265c656f9b370da660531db8cc6bf0a2e110a6";
    hash = "sha256-X9M/ZATYXUiE4oGorPBnsdaKnKaObarnMRh6QEfkBls=";
  };

  muon = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "muon";
    rev = "62af239";
    hash = "sha256-k883mKwuP35f0WtwX8ybl9uYbvA3y6Vxtv2EJMpZDEs=";
  };
in
stdenv.mkDerivation rec {
  pname = "mesonlsp";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "mesonlsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-pN8MCqrRfVpmM8KWa7HPTghoegplM4bP/HRVJVs05iE=";
  };

  postUnpack = ''
    pushd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${tree-sitter} tree-sitter-${tsVersion}
    cp -R --no-preserve=mode,ownership ${tree-sitter-meson} tree-sitter-meson
    cp -R --no-preserve=mode,ownership ${tree-sitter-ini} tree-sitter-ini
    cp -R --no-preserve=mode,ownership ${sha256} sha256
    cp -R --no-preserve=mode,ownership ${ada} ada
    cp -R --no-preserve=mode,ownership ${muon} muon
    popd
  '';

  mesonFlags = [ "-Dbenchmarks=false" ];

  patches = [ ./build_flags.patch ];

  postPatch = ''
    patchShebangs .
    pushd subprojects
    cp packagefiles/tree-sitter-${tsVersion}/* tree-sitter-${tsVersion}
    cp packagefiles/tree-sitter-meson/* tree-sitter-meson
    cp packagefiles/tree-sitter-ini/* tree-sitter-ini
    cp packagefiles/sha256/* sha256
    cp packagefiles/ada/* ada
    popd
  '';

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
  ];

  buildInputs = [
    tomlplusplus
    nlohmann_json
    curl
    libarchive
    libuuid
    libpkgconf
    libunwind
    gtest
  ];

  meta = with lib; {
    description = "An unofficial, unendorsed language server for meson written in C";
    homepage = "https://github.com/JCWasmx86/mesonlsp";
    changelog = "https://github.com/JCWasmx86/mesonlsp/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ traxys ];
    mainProgram = "mesonlsp";
    platforms = platforms.all;
  };
}
