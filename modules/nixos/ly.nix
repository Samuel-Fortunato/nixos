{ config, lib, ... }:
{
  config = lib.mkIf config.services.displayManager.ly.enable {
    services.displayManager.ly.settings = {
      bigclock = true;
      session_log = null;
    };

    systemd.tmpfiles.rules = [
      "d /etc/ly/custom-sessions 0755 root root -"
    ];
  };
}
