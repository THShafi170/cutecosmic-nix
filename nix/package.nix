{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cargo,
  rustPlatform,
  qt6,
  corrosion,
  rustc,
}:
stdenv.mkDerivation (final: {
  pname = "cutecosmic";
  version = "unstable-2026-01-20";

  src = ../.;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (final) pname version;
    src = final.src + "/bindings";
    hash = "sha256-f8/ZgYMg9q6ClPHI70f609XJCooHsoaBR2l6SBQ4IyU=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cmake
    pkg-config
  ];

  buildInputs = [
    corrosion
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwebengine
  ];

  cmakeFlags = [
    "-DQT_INSTALL_PLUGINS=${qt6.qtbase.qtPluginPrefix}"
  ];

  postPatch = ''
    ln -sf bindings/Cargo.lock Cargo.lock
  '';

  meta = with lib; {
    description = "Qt platform theme plugin for the COSMIC desktop environment";
    homepage = "https://github.com/tenshou170/cutecosmic-nix";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
