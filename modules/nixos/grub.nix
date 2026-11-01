{ config, lib, ... }:
{
  config = lib.mkIf config.boot.loader.grub.enable {
    boot.loader = {
      timeout = 0;

      grub = {
        configurationLimit = 5;
        timeoutStyle = "hidden";
      };
    };
  };
}
