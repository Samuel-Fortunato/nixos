{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.modules.xdg.enable = lib.mkEnableOption "XDG configuration";
  config = lib.mkIf config.my.modules.xdg.enable {
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
      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/mount-point" = "yazi.desktop";
          "application/pdf" = "org.pwmt.zathura.desktop";
          "image/png" = "org.gnome.Loupe.desktop";
          "image/jpeg" = "org.gnome.Loupe.desktop";
          "image/webp" = "org.gnome.Loupe.desktop";
          "image/gif" = "org.gnome.Loupe.desktop";
          "image/svg+xml" = "org.gnome.Loupe.desktop";
          "image/tiff" = "org.gnome.Loupe.desktop";
          "image/avif" = "org.gnome.Loupe.desktop";
          "image/heic" = "org.gnome.Loupe.desktop";
          "image/bmp" = "org.gnome.Loupe.desktop";
        };
      };
      configFile."xdg-desktop-portal-termfilechooser/config".text =
        "[filechooser] default_dir=$HOME open_mode=default save_mode=last ";
    };
  };
}
