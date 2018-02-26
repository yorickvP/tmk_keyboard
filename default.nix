{ pkgs ? (import <nixpkgs> {}) }:
{
  ergodox = pkgs.callPackage ./keyboard/ergodox {};
}
