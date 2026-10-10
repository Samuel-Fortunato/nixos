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

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      default_dir=$HOME
      open_mode=default
      save_mode=last
    '';
  };
}
