{...}: {
  home.sessionVariables.HYPRLAND_VIRTIO_WORKAROUND = "1";

  my.profiles = {
    cli.enable = true;
    desktop.enable = true;
    media.enable = true;
    development.enable = true;
  };
}
