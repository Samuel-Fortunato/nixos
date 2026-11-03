{ config, lib, pkgs, ... }:

{
  options.my.modules.razer.enable =
    lib.mkEnableOption "Razer configuration tools";

  config = lib.mkIf config.my.modules.razer.enable {
    home.packages = with pkgs; [
      polychromatic
    ];
  };
}
