{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.modules.proton-drive.enable = lib.mkEnableOption "Proton Drive synchronization";
  config = lib.mkIf config.my.modules.proton-drive.enable {
    home.packages = [ pkgs.rclone ];

    systemd.user.services.proton-drive-bisync = {
      Unit.Description = "Synchronize Desktop with Proton Drive";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.rclone}/bin/rclone bisync /home/samuel/Desktop proton: --max-delete 50 --resilient --recover";
      };
    };
    systemd.user.timers.proton-drive-bisync = {
      Unit.Description = "Run Proton Drive sync every five minutes";
      Timer = {
        OnStartupSec = "2m";
        OnUnitActiveSec = "5m";
        Unit = "proton-drive-bisync.service";
      };
      Install.WantedBy = [ "timers.target" ];
    };
    programs.zsh.siteFunctions.sync-desktop = ''
      if systemctl --user start proton-drive-bisync.service; then
        if [ "$(systemctl --user show proton-drive-bisync.service -p Result --value)" = "success" ]; then
          echo "Desktop synced successfully. Safe to shut down."
        else
          echo "Desktop sync failed. Do not switch PCs yet."
          return 1
        fi
      else
        echo "Desktop sync failed. Do not switch PCs yet."
        return 1
      fi
    '';
  };
}
