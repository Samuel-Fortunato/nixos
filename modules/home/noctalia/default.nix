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

  noctaliaSettings = (import ./config.nix {inherit pkgs;}).settings;

  noctaliaSeed =
    (pkgs.formats.toml {}).generate
    "noctalia-settings.toml"
    noctaliaSettings;
in {
imports = [./watcher.nix];

  options.my.modules.noctalia.enable = lib.mkEnableOption "Noctalia desktop shell";

  config = lib.mkIf config.my.modules.noctalia.enable {
    programs.noctalia =
      {
        enable = true;
        systemd.enable = true;
      }
      // lib.optionalAttrs (monitorName != "eDP-1") {
        # Keep the previous configuration for the VM temporarily.
        settings = builtins.replaceStrings ["@MONITOR@"] [monitorName] (
          builtins.readFile ./config/config.toml
        );
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

    home.activation = lib.optionalAttrs (monitorName == "eDP-1") {
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
