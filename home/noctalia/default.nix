{ pkgs, monitorName, ... }: {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/config.toml".text =
    builtins.replaceStrings [ "@MONITOR@" ] [ monitorName ]
      (builtins.readFile ./config/config.toml);
}
