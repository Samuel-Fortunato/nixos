{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.modules.gtk.enable = lib.mkEnableOption "GTK configuration";

  config = lib.mkIf config.my.modules.gtk.enable {
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    };

    home.sessionVariables.GSK_RENDERER = "gl";
  };
}
