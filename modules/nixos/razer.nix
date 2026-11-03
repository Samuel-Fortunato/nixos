{ config, lib, ... }:

{
  options.my.modules.razer.enable =
    lib.mkEnableOption "Razer device support";

  config = lib.mkIf config.my.modules.razer.enable {
    hardware.openrazer = {
      enable = true;
      users = [ "samuel" ];
    };
  };
}
