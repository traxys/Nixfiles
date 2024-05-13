{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libevdev,
  xdotool,
  xorg,
}:
stdenv.mkDerivation {
  pname = "wayland-push-to-talk-fix";
  version = "unstable-2023-12-19";

  src = fetchFromGitHub {
    owner = "Rush";
    repo = "wayland-push-to-talk-fix";
    rev = "490f43054453871fe18e7d7e9041cfbd0f1d9b7d";
    hash = "sha256-ZRSgrQHnNdEF2PyaflmI5sUoKCxtZ0mQY/bb/9PH64c=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libevdev
    xdotool
    xorg.libX11.dev
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 push-to-talk $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "This fixes the inability to use push to talk in Discord when running Wayland";
    homepage = "https://github.com/Rush/wayland-push-to-talk-fix";
    license = licenses.mit;
    maintainers = with maintainers; [ traxys ];
    mainProgram = "wayland-push-to-talk-fix";
    platforms = platforms.all;
  };
}
