{ config, lib, ... }:
{
  options.my.modules.hyprland.enable = lib.mkEnableOption "Hyprland user configuration";

  config = lib.mkIf config.my.modules.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = false;
    };

    xdg.configFile = {
      "hypr" = {
        source = ./config;
        recursive = true;
      };
      "xdg-desktop-portal-termfilechooser/config".text =
        "[filechooser] default_dir=$HOME open_mode=default save_mode=last ";
    };
  };
}
