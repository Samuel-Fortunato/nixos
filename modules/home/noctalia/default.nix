{
  config,
  lib,
  pkgs,
  monitorName,
  ...
}: let
  uuctl-noctalia = pkgs.writeShellScriptBin "uuctl" ''
    exec ${pkgs.uwsm}/bin/uuctl "$@" noctalia dmenu -p
  '';

  # Change both monitor-name values and attribute keys (e.g. widget IDs).
  remapMonitor = value:
    if builtins.isAttrs value then
      lib.mapAttrs' (
        name: child:
          lib.nameValuePair
            (builtins.replaceStrings ["@MONITOR@"] [monitorName] name)
            (remapMonitor child)
      ) value
    else if builtins.isList value then
      builtins.map remapMonitor value
    else if builtins.isString value then
      builtins.replaceStrings ["@MONITOR@"] [monitorName] value
    else
      value;

  noctaliaSettings = remapMonitor (import ./config.nix {inherit pkgs;}).settings;

  noctaliaSeed =
    (pkgs.formats.toml {}).generate
    "noctalia-settings.toml"
    noctaliaSettings;
in {
imports = [./watcher.nix];

  options.my.modules.noctalia.enable = lib.mkEnableOption "Noctalia desktop shell";

  config = lib.mkIf config.my.modules.noctalia.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };

    home.packages = with pkgs; [
      uuctl-noctalia

      # Hypr Screen Mirror
      socat

      # Crashes
      jq
      libnotify

      # Wallpaper Widget
      imagemagick
    ];

    home.activation = {
      noctaliaSettingsSeed = lib.hm.dag.entryAfter ["writeBoundary"] ''
        stateDir="''${NOCTALIA_STATE_HOME:-''${XDG_STATE_HOME:-$HOME/.local/state}}/noctalia"
        settingsFile="$stateDir/settings.toml"

        if [ ! -e "$settingsFile" ] && [ ! -L "$settingsFile" ]; then
          mkdir -p "$stateDir"
          install -m 600 ${noctaliaSeed} "$settingsFile"
          touch "$stateDir/.setup-complete"
        fi
      '';
    };
  };
}
