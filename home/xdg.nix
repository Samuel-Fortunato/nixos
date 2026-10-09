{ pkgs, ... }: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      music = null;
      projects = null;
      publicShare = null;
      templates = null;
      videos = null;
    };
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
      config = {
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
    };
  };
}
