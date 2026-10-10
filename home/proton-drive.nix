{ pkgs, ... }: {
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
}
