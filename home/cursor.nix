{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.modules.cursor.enable = lib.mkEnableOption "Cursor theme";

  config = lib.mkIf config.my.modules.cursor.enable {
    home.pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;

      gtk.enable = config.my.modules.gtk.enable;
      x11.enable = true;
      hyprcursor.enable = config.my.modules.hyprland.enable;
    };
  };
}
