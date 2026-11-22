{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.profiles.graphical.enable =
    lib.mkEnableOption "Shared graphical NixOS environment";

  config = lib.mkIf config.my.profiles.graphical.enable {
    networking.networkmanager.enable = lib.mkDefault true;
    hardware.graphics.enable = lib.mkDefault true;

    services = {
      pipewire.enable = lib.mkDefault true;
      accounts-daemon.enable = lib.mkDefault true;
      udisks2.enable = lib.mkDefault true;

      displayManager.noctalia-greeter.enable = lib.mkDefault true;
      gnome.gnome-keyring.enable = lib.mkDefault true;
    };
    programs.hyprland.enable = lib.mkDefault true;
    security.polkit.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      glib
    ];
  };
}
