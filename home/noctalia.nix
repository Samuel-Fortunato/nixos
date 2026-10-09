{ pkgs, ... }: {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia" = {
    source = ./noctalia;
    # recursive = true;
  };
}
