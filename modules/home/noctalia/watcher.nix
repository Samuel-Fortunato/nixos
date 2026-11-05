{
  config,
  lib,
  pkgs,
  monitorName,
  ...
}:
let
  enabled = config.my.modules.noctalia.enable && monitorName == "eDP-1";

  exporter = pkgs.writeShellApplication {
    name = "noctalia-settings-export";
    runtimeInputs = [ pkgs.python3 pkgs.nix ];
    text = ''
      exec python3 ${./export-settings.py} \
        "$HOME/.local/state/noctalia/settings.toml" \
        /etc/nixos/modules/home/noctalia/config.nix \
        ${lib.escapeShellArg monitorName}
    '';
  };
in
{
  systemd.user.services.noctalia-settings-export = lib.mkIf enabled {
    Unit.Description = "Export Noctalia GUI settings to config.nix";
    Service = {
      Type = "oneshot";
      ExecStart = "${exporter}/bin/noctalia-settings-export";
    };
  };

  systemd.user.paths.noctalia-settings-export = lib.mkIf enabled {
    Unit.Description = "Watch Noctalia GUI settings for changes";
    Path.PathChanged = "%h/.local/state/noctalia/settings.toml";
    Install.WantedBy = [ "default.target" ];
  };
}
