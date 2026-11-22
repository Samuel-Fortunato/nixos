{ config, lib, ... }: {
  options.my.profiles.media.enable = lib.mkEnableOption "Music and video applications";

  config = lib.mkIf config.my.profiles.media.enable {
    my.modules = {
      spotify.enable = lib.mkDefault true;
      showtime.enable = lib.mkDefault true;
      noctalia.musicWallpaper.enable = lib.mkDefault true;
    };
  };
}
