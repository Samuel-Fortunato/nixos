{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.desktop-commander;

  desktopCommander = pkgs.writeShellApplication {
    name = "desktop-commander-remote";

    runtimeInputs = [
      pkgs.nodejs_24
    ];

    text = ''
      exec npx --yes @wonderwhy-er/desktop-commander@latest remote --disable-no-sleep "$@"
    '';
  };
in {
  options.my.modules.desktop-commander = {
    enable = lib.mkEnableOption "Desktop Commander Remote";

    autoStart = lib.mkEnableOption "automatic Desktop Commander Remote startup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      desktopCommander
    ];

    systemd.user.services = lib.mkIf cfg.autoStart {
      desktop-commander = {
        Unit = {
          Description = "Desktop Commander Remote";
          After = ["network-online.target"];
        };

        Service = {
          Type = "simple";
          ExecStart = "${desktopCommander}/bin/desktop-commander-remote";
          Restart = "on-failure";
          RestartSec = 10;
        };

        Install.WantedBy = ["default.target"];
      };
    };
  };
}
