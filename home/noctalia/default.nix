{ monitorName, ... }: {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings =
      builtins.replaceStrings
        [ "@MONITOR@" ]
        [ monitorName ]
        (builtins.readFile ./config/config.toml);
  };
}
