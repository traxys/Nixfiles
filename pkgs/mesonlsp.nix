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
  python3
}: let
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
    rev = "e7d0aae70c695a1adec81b9a05429474ee5c1bc1";
    hash = "sha256-dsvxqSr+Hl5GKYj55MU0o4lHzgPbykuf6sQ/9h+bBPQ=";
  };
in
  stdenv.mkDerivation rec {
    pname = "mesonlsp";
    version = "unstable-2024-03-11";

    src = fetchFromGitHub {
      owner = "JCWasmx86";
      repo = "mesonlsp";
      rev = "fb28856";
      hash = "sha256-dHtKSQ+/oq5NzqIhXJ7luVBQ2V7Ec6ikLwlYMzaem80=";
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

    mesonFlags = ["-Dbenchmarks=false"];

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
      maintainers = with maintainers; [traxys];
      mainProgram = "mesonlsp";
      platforms = platforms.all;
    };
  }
