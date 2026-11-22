{
  config,
  lib,
  pkgs,
  monitorName,
  ...
}:
let
  enabled = config.my.modules.noctalia.enable && config.my.modules.noctalia.exporter.enable;
  repoPath = config.my.modules.noctalia.exporter.repoPath;

  noctaliaPackage =
    if config.programs.noctalia.package != null
    then config.programs.noctalia.package
    else pkgs.noctalia;

  exporter = pkgs.writeShellApplication {
    name = "noctalia-settings-export";
    runtimeInputs = [ pkgs.python3 pkgs.nix noctaliaPackage ];
    text = ''
      exec python3 ${./export-settings.py} \
        "$HOME/.local/state/noctalia/settings.toml" \
        ${lib.escapeShellArg "${repoPath}/modules/home/noctalia/config.generated.nix"} \
        ${lib.escapeShellArg monitorName}
    '';
  };
in
{
  options.my.modules.noctalia.exporter = {
    enable = lib.mkEnableOption "Noctalia settings exporter";
    repoPath = lib.mkOption {
      type = lib.types.str;
      default = "/etc/nixos";
      description = "Writable configuration checkout used by the Noctalia exporter.";
    };
  };

  config = lib.mkIf enabled {
    systemd.user.services.noctalia-settings-export = {
      Unit.Description = "Export Noctalia GUI settings to config.nix";
      Service = {
        Type = "oneshot";
        ExecStart = "${exporter}/bin/noctalia-settings-export";
      };
    };

    systemd.user.paths.noctalia-settings-export = {
      Unit.Description = "Watch Noctalia GUI settings for changes";
      Path.PathChanged = "%h/.local/state/noctalia/settings.toml";
      Install.WantedBy = [ "default.target" ];
    };
  };
}
