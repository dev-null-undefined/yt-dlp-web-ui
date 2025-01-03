{ lib
, stdenv
, nodejs
, pnpm
}:
let common = import ./common.nix { inherit lib; }; in
stdenv.mkDerivation (finalAttrs: {
  pname = "yt-dlp-web-ui-frontend";

  inherit (common) version;

  src = lib.fileset.toSource {
    root = ../frontend;
    fileset = ../frontend;
  };

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    mkdir -p $out/dist
    cp -r dist/* $out/dist
  '';

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PDgxMkzesD0RhElEU8tc/w+j0OGq99vHO5IL9TRs0qo=";
  };

  inherit (common) meta;
})
