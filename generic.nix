{
  writeScript, stdenv, bash,
    teensy-loader-cli,
  avrbinutils, avrgcc, avrlibc,
    target, path, mcu, dev, installer,
    extraArgs,
}:

let
  f-avrbinutils = avrbinutils.overrideDerivation (z: {
    CFLAGS = [ "-Wno-error" ];
  });
f-avrgcc = avrgcc.override { avrbinutils = f-avrbinutils; };
f-avrlibc = avrlibc.override { avrbinutils = f-avrbinutils; avrgcc = f-avrgcc; };
installers = {
  teensy = writeScript "flash-keyboard" ''
    #!${bash}/bin/bash
    DIR="$( cd "$( dirname "''${BASH_SOURCE[0]}" )" && pwd )"
    ${teensy-loader-cli}/bin/teensy-loader-cli --mcu ${mcu} -w -v $DIR/${target}.hex
  '';
};
in

stdenv.mkDerivation (rec {
  src = ./.;
  makeFlags = "-C ${path}";
  installPhase = ''
    mkdir $out
    cp ${path}/${target}.{hex,lss,eep,sym,elf} $out
    cp ${installers.${installer}} $out/flash
  '';
  buildInputs = [ f-avrbinutils f-avrgcc f-avrlibc ];
  name = "tmk-ergodox";
  CFLAGS="-I${f-avrlibc}/avr/include -L${f-avrlibc}/avr/lib/${dev} -B${f-avrlibc}/avr/lib";
  ASFLAGS= CFLAGS;
} // extraArgs)
