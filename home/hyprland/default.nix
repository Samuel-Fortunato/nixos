{ ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

  xdg.configFile."hypr" = {
    source = ./config;
	 recursive = true;
  };
}
