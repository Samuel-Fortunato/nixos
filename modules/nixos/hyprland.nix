{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.programs.hyprland.enable {
    programs.hyprland.withUWSM = true;

    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-termfilechooser
      ];

      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];

        "org.freedesktop.impl.portal.FileChooser" = [
          "termfilechooser"
        ];
      };
    };
  };
}
