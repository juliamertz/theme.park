{
  description = "Theme.park package overlays";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs }:
    let
      platform = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${platform};
    in
    {
      overlays = import ./overlays {
        inherit pkgs;
        themeType = "community-theme-options"; # theme-options or community-theme-options
        themeName = "rose-pine-moon";
      };

      packages.${platform} = {
        default = pkgs.stdenv.mkDerivation {
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
