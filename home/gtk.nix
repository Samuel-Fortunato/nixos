{ pkgs, ... }: {
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };
}
