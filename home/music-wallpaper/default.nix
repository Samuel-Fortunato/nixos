{ config, lib, pkgs, ... }:
let
  pythonWithPillow = pkgs.python3.withPackages (pythonPackages: [ pythonPackages.pillow ]);

  musicWallpaper = pkgs.writeShellApplication {
    name = "noctalia-music-wallpaper";
    runtimeInputs = [
      pythonWithPillow
      pkgs.playerctl
      pkgs.hyprland
      pkgs.systemd
      pkgs.dejavu_fonts
    ] ++ lib.optional (config.programs.noctalia.package != null) config.programs.noctalia.package;
    text = ''
      export NOCTALIA_FONT_FILE="${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf"
      exec python3 ${./music_wallpaper.py} "$@"
    '';
  };

  selectorArt = pkgs.runCommand "noctalia-wallpaper-mode-selectors" {
    nativeBuildInputs = [ pythonWithPillow ];
  } ''
    mkdir -p "$out"
    NOCTALIA_FONT_FILE="${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf" python3 ${./selector_art.py} "$out"
  '';
in
{
  home.packages = [ musicWallpaper pkgs.playerctl ];

  # These are selectable entries in Noctalia's existing wallpaper directory.
  home.file."Pictures/Wallpapers/00-music-theme.png".source = "${selectorArt}/00-music-theme.png";
  home.file."Pictures/Wallpapers/01-carroussel.png".source = "${selectorArt}/01-carroussel.png";

  # Noctalia loads extra TOML files from ~/.config/noctalia as a config stack.
  # This hook file is kept separate from the user's existing config.toml.
  xdg.configFile."noctalia/zz-music-wallpaper.toml".text = ''
    [hooks]
    started = "${musicWallpaper}/bin/noctalia-music-wallpaper startup"
    wallpaper_changed = "${musicWallpaper}/bin/noctalia-music-wallpaper wallpaper-hook"
  '';

  systemd.user.services.noctalia-music-wallpaper = {
    Unit = {
      Description = "Update Noctalia wallpaper from the currently playing MPRIS track";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${musicWallpaper}/bin/noctalia-music-wallpaper music-monitor";
      Restart = "on-failure";
      RestartSec = "3s";
    };
  };

  systemd.user.services.noctalia-wallpaper-carousel = {
    Unit = {
      Description = "Rotate ordinary wallpapers while Noctalia carousel mode is selected";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${musicWallpaper}/bin/noctalia-music-wallpaper carousel-monitor";
      Restart = "on-failure";
      RestartSec = "3s";
      Environment = [ "NOCTALIA_WALLPAPER_INTERVAL=600" ];
    };
  };
}
