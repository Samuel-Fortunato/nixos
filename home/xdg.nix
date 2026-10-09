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

    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      default_dir=$HOME
      open_mode=default
      save_mode=last
    '';
  };
}
