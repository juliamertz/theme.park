{
  pkgs,

  themeType,
  themeName,
  ...
}:
let
  mkThemedOverlay =
    path: prev:
    pkgs.callPackage path {
      prev = prev;
      inherit themeName themeType;
    };
in
{
  qbittorrent-nox = _: prev: mkThemedOverlay ./qbittorrent.nix prev;
}
