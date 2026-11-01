{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.modules.mega-sync.enable = lib.mkEnableOption "MEGA Synchronization";

  config = lib.mkIf config.my.modules.mega-sync.enable {
    home.packages = [
      pkgs.megacmd

    ];

    systemd.user.services.megacmd = {
      Unit = {
        Description = "MEGA CMD synchronization daemon";
      };

      Service = {
        ExecStart = "${pkgs.megacmd}/bin/mega-cmd-server";
        Restart = "on-failure";
        RestartSec = 10;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
