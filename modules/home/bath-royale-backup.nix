{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.bath-royale-backup;
  # Only non-sensitive executable arguments enter these declarative units. The
  # manager's own pinned flake provides its runtime and owns ALL backup logic.
  escape = value: "\"" + lib.replaceStrings ["\\" "\"" "%" "$"] ["\\\\" "\\\"" "%%" "$$"] value + "\"";
  command = action: lib.concatMapStringsSep " " escape [
    "${pkgs.nix}/bin/nix"
    "run"
    "--no-write-lock-file"
    cfg.managerRoot
    "--"
    "--root"
    cfg.managerRoot
    "backup"
    action
  ];
in {
  options.my.modules.bath-royale-backup = {
    enable = lib.mkEnableOption "Bath Royale verified daily backup workflow";
    managerRoot = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Documents/bath_royale_manager";
      description = "Absolute path to the private manager checkout; never a credential path.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = lib.hasPrefix "/" cfg.managerRoot && !(lib.hasInfix "\n" cfg.managerRoot);
      message = "Bath Royale managerRoot must be an absolute non-sensitive path.";
    }];

    systemd.user.services.broyale-backup = {
      Unit = {
        Description = "Backup diário do Bath Royale";
        After = ["megacmd.service"];
        Wants = ["megacmd.service"];
        OnFailure = ["broyale-backup-failure.service"];
        StartLimitIntervalSec = "6h";
        StartLimitBurst = 2;
      };
      Service = {
        Type = "oneshot";
        UMask = "0077";
        ExecStart = command "scheduled-run" + " --environment managed";
        TimeoutStartSec = "30min";
        TimeoutStopSec = "5min";
        KillMode = "control-group";
        Restart = "on-failure";
        RestartSec = "15min";
      };
    };

    systemd.user.services.broyale-backup-failure = {
      Unit.Description = "Falha do backup Bath Royale";
      Service = {
        Type = "oneshot";
        ExecStart = command "notify-failure";
      };
    };

    systemd.user.timers.broyale-backup = {
      Unit.Description = "Backup diário do Bath Royale";
      Timer = {
        OnCalendar = "*-*-* 09:00:00 Europe/Lisbon";
        Persistent = true;
        RandomizedDelaySec = "15min";
        AccuracySec = "1min";
        Unit = "broyale-backup.service";
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
