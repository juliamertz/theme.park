{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          config,
          pkgs,
          lib,
          system,
          ...
        }:
        {
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "themepark-app";
            version = "1.19.1";

            src = ../.;

            nativeBuildInputs = [ pkgs.python3 ];

            buildPhase = ''
              python3 ./themes.py

              mkdir -p $out/app/themepark
              cp -r ./css $out/app/themepark/css
              cp -r ./resources $out/app/themepark/resources
              cp -r ./docker-mods $out/app/themepark/docker-mods
              cp ./themes.py $src/index.html $src/CNAME $out/app/themepark/
              cp -r ./docker/root $out/docker-root
            '';
          };
        };
    };
}
