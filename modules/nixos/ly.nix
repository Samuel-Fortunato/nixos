{ config, lib, ... }:
{
  config = lib.mkIf config.services.displayManager.ly.enable {
    services.displayManager.ly.settings = {
      bigclock = true;
      session_log = null;
    };
  };
}
