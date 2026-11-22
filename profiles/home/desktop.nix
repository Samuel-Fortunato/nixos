{ config, lib, ... }: {
  options.my.profiles.desktop.enable = lib.mkEnableOption "Hyprland and desktop applications";

  config = lib.mkIf config.my.profiles.desktop.enable {
    my.modules = {
      kitty.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
      noctalia.enable = lib.mkDefault true;
      seahorse.enable = lib.mkDefault true;
      gtk.enable = lib.mkDefault true;
      cursor.enable = lib.mkDefault true;
      xdg.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      thunar.enable = lib.mkDefault true;
      trash.enable = lib.mkDefault true;
      udiskie.enable = lib.mkDefault true;
      chrome.enable = lib.mkDefault true;
      zathura.enable = lib.mkDefault true;
      loupe.enable = lib.mkDefault true;
      calculator.enable = lib.mkDefault true;
      litemdview.enable = lib.mkDefault true;
      proton-pass.enable = lib.mkDefault true;
      evtest.enable = lib.mkDefault true;
    };
  };
}
