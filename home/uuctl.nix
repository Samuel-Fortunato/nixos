{ pkgs, ... }:

let
  uuctl-noctalia = pkgs.writeShellScriptBin "uuctl" ''
    exec ${pkgs.uwsm}/bin/uuctl "$@" noctalia dmenu -p
  '';
in
{
  home.packages = [
    uuctl-noctalia
  ];
}
