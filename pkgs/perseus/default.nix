{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, rustPlatform
, openssl
, zstd
, darwin
, bonnie
}:

stdenv.mkDerivation rec {
  pname = "perseus";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "framesurge";
    repo = "perseus";
    rev = "v${version}";
    hash = "sha256-0jGXoSZeAt+Fo08hGEHiYcookqean6qD7F6mhTGfb2M=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  buildAndTestSubdir = "packages/perseus-cli";
  cargoBuildType = "release";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoInstallHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ];

  buildInputs = [
    openssl
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
  ];

  checkPhase = ''
    bonnie test cli
  '';

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "A state-driven web development framework for Rust with full support for server-side rendering and static generation";
    homepage = "https://github.com/framesurge/perseus";
    changelog = "https://github.com/framesurge/perseus/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
