{
  config,
  lib,
  pkgs,
  monitorName,
  ...
}: let
  noctaliaCaffeineLock = pkgs.writeShellApplication {
    name = "noctalia-caffeine-lock";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      systemd
    ];
    text = builtins.readFile ./caffeine-lock.sh;
  };
  noctaliaAccept = pkgs.writeShellApplication {
    name = "noctalia-accept";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.nix
    ];
    text = builtins.readFile ./accept-settings.sh;
  };

  uuctl-noctalia = pkgs.writeShellScriptBin "uuctl" ''
    exec ${pkgs.uwsm}/bin/uuctl "$@" noctalia dmenu -p
  '';

  # Change both monitor-name values and attribute keys (e.g. widget IDs).
  remapMonitor = value:
    if builtins.isAttrs value
    then
      lib.mapAttrs' (
        name: child:
          lib.nameValuePair
          (builtins.replaceStrings ["@MONITOR@"] [monitorName] name)
          (remapMonitor child)
      )
      value
    else if builtins.isList value
    then builtins.map remapMonitor value
    else if builtins.isString value
    then builtins.replaceStrings ["@MONITOR@"] [monitorName] value
    else value;

  noctaliaSettings = remapMonitor (import ./config.nix {inherit pkgs;}).settings;
in {
  imports = [./watcher.nix];

  options.my.modules.noctalia.enable = lib.mkEnableOption "Noctalia desktop shell";

  config = lib.mkIf config.my.modules.noctalia.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = noctaliaSettings;
    };

    home.packages = with pkgs; [
      # apply noctalia GUI settings
      noctaliaAccept

      # uuctl via noctalia menu
      uuctl-noctalia

      # Hypr Screen Mirror
      socat

      # Crashes
      jq
      libnotify

      # Wallpaper Widget
      imagemagick
    ];

    home.file.".local/bin/noctalia-caffeine-lock".source = "${noctaliaCaffeineLock}/bin/noctalia-caffeine-lock";

    home.activation.noctaliaSettingsRestore = lib.hm.dag.entryAfter ["linkGeneration"] ''
      stateDir="''${NOCTALIA_STATE_HOME:-''${XDG_STATE_HOME:-$HOME/.local/state}}/noctalia"

      ${pkgs.python3}/bin/python3 ${./restore-settings.py} \
        "$stateDir/settings.toml"

      touch "$stateDir/.setup-complete"
    '';
  };
}
