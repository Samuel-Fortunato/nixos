{
  config,
  lib,
  pkgs,
  monitorName,
  ...
}:
let
  uuctl-noctalia = pkgs.writeShellScriptBin "uuctl" ''
    exec ${pkgs.uwsm}/bin/uuctl "$@" noctalia dmenu -p
  '';
in
{
  options.my.modules.noctalia.enable = lib.mkEnableOption "Noctalia desktop shell";

  config = lib.mkIf config.my.modules.noctalia.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = builtins.replaceStrings [ "@MONITOR@" ] [ monitorName ] (
        builtins.readFile ./config/config.toml
      );
    };

    home.packages = [ uuctl-noctalia ];
  };
}
