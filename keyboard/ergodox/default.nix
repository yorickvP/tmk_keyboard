{pkgs? import <nixpkgs> {}, keymap ? "yorick" }:
pkgs.callPackage ../../generic.nix {
  path = "keyboard/ergodox";
  mcu = "atmega32u4";
  dev = "avr5";
  target = "ergodox_lufa";
  installer = "teensy";
  extraArgs = {
    name = "tmk-ergodox";
    makefile = "Makefile.lufa";
    KEYMAP=keymap;
  };
}
