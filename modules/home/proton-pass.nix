{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.proton-pass;
in
{
  options.my.modules.proton-pass.enable = lib.mkEnableOption "Proton Pass password manager";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.proton-pass ];
  };
}
