{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "bonnie";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "arctic-hen7";
    repo = "bonnie";
    rev = "v${version}";
    hash = "sha256-mFy3rvISFTbtB4Jn3vnjRG1cfQpvaD8iomgTI32lJtY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-fdkw2QB4n2kbuQtvQ0IagGxEvlnurExTW4UKdwSx93M=";

  doCheck = false;

  meta = with lib; {
    description = "Simple, cross-platform, and fast command aliases with superpowers";
    homepage = "https://github.com/arctic-hen7/bonnie";
    changelog = "https://github.com/arctic-hen7/bonnie/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
