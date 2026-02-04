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
  version = "master-2026-02-04";

  src = ../.;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (final) pname version;
    src = final.src + "/bindings";
    hash = "sha256-+1z0VoxDeOYSmb7BoFSdrwrfo1mmwkxeuEGP+CGFc8Y=";
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
